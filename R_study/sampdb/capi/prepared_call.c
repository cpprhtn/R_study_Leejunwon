/*
 * prepared_call.c - demonstrate how to use prepared statement support
 * for CALL statements and access to final values of OUT/INOUT procedure
 * parameters.
 *
 * For simplicity, the code assumes all parameters and result set column
 * values have INT type (and thus buffer type MYSQL_TYPE_LONG).
 *
 * To do:
 * - Maybe do something different with SERVER_PS_OUT_PARAMS
 */

#include <my_global.h>
#include <my_sys.h>
#include <m_string.h>   /* for strdup() */
#include <mysql.h>
#include <my_getopt.h>

#ifdef HAVE_OPENSSL
enum options_client
{
  OPT_SSL_SSL=256,
  OPT_SSL_KEY,
  OPT_SSL_CERT,
  OPT_SSL_CA,
  OPT_SSL_CAPATH,
  OPT_SSL_CIPHER,
  OPT_SSL_VERIFY_SERVER_CERT
};
#endif

static char *opt_host_name = NULL;    /* server host (default=localhost) */
static char *opt_user_name = NULL;    /* username (default=login name) */
static char *opt_password = NULL;     /* password (default=none) */
static unsigned int opt_port_num = 0; /* port number (use built-in value) */
static char *opt_socket_name = NULL;  /* socket name (use built-in value) */
static char *opt_db_name = NULL;      /* database name (default=none) */
static unsigned int opt_flags = 0;    /* connection flags (none) */

#include <sslopt-vars.h>

static int ask_password = 0;          /* whether to solicit password */

static const char *client_groups[] = { "client", NULL };

static struct my_option my_opts[] =   /* option information structures */
{
  {"help", '?', "Display this help and exit",
  NULL, NULL, NULL,
  GET_NO_ARG, NO_ARG, 0, 0, 0, 0, 0, 0},
  {"host", 'h', "Host to connect to",
  (uchar **) &opt_host_name, NULL, NULL,
  GET_STR, REQUIRED_ARG, 0, 0, 0, 0, 0, 0},
  {"password", 'p', "Password",
  (uchar **) &opt_password, NULL, NULL,
  GET_STR, OPT_ARG, 0, 0, 0, 0, 0, 0},
  {"port", 'P', "Port number",
  (uchar **) &opt_port_num, NULL, NULL,
  GET_UINT, REQUIRED_ARG, 0, 0, 0, 0, 0, 0},
  {"socket", 'S', "Socket path",
  (uchar **) &opt_socket_name, NULL, NULL,
  GET_STR, REQUIRED_ARG, 0, 0, 0, 0, 0, 0},
  {"user", 'u', "User name",
  (uchar **) &opt_user_name, NULL, NULL,
  GET_STR, REQUIRED_ARG, 0, 0, 0, 0, 0, 0},

#include <sslopt-longopts.h>

  { NULL, 0, NULL, NULL, NULL, NULL, GET_NO_ARG, NO_ARG, 0, 0, 0, 0, 0, 0 }
};

/*
 * Print diagnostic message. If conn is non-NULL, print error information
 * returned by server.
 */

static void
print_error (MYSQL *conn, char *message)
{
  fprintf (stderr, "%s\n", message);
  if (conn != NULL)
  {
    fprintf (stderr, "Error %u (%s): %s\n",
             mysql_errno (conn), mysql_sqlstate (conn), mysql_error (conn));
  }
}

/*
 * Like print_error(), but use statement handler rather than
 * connection handler to access error information.
 */

static void
print_stmt_error (MYSQL_STMT *stmt, char *message)
{
  fprintf (stderr, "%s\n", message);
  if (stmt != NULL)
  {
    fprintf (stderr, "Error %u (%s): %s\n",
             mysql_stmt_errno (stmt),
             mysql_stmt_sqlstate (stmt),
             mysql_stmt_error (stmt));
  }
}

static my_bool
get_one_option (int optid, const struct my_option *opt, char *argument)
{
  switch (optid)
  {
  case '?':
    my_print_help (my_opts);  /* print help message */
    exit (0);
  case 'p':                   /* password */
    if (!argument)            /* no value given; solicit it later */
      ask_password = 1;
    else                      /* copy password, overwrite original */
    {
      opt_password = strdup (argument);
      if (opt_password == NULL)
      {
        print_error (NULL, "could not allocate password buffer");
        exit (1);
      }
      while (*argument)
        *argument++ = 'x';
      ask_password = 0;
    }
    break;
#include <sslopt-case.h>
  }
  return (0);
}

/*
 * Process one result set from executing a prepared statement.
 * Handles only column values of type INT (MYSQL_TYPE_LONG), although
 * values can be NULL.
 *
 * Return zero for success and nonzero if an error occurred.
 */

/* #@ _PROCESS_RESULT_SET_ */
static int process_result_set (MYSQL_STMT *stmt, int num_cols)
{
MYSQL_FIELD *fields;     /* pointer to result set metadata */
MYSQL_BIND  *params;     /* pointer to output buffers */
int         int_data[3];  /* output parameter values */
my_bool     is_null[3];  /* output parameter nullability */
int         i;

  MYSQL_RES *metadata = mysql_stmt_result_metadata (stmt);
  if (metadata == NULL)
  {
    print_stmt_error (stmt, "Cannot get statement result metadata");
    return (1);
  }

  fields = mysql_fetch_fields (metadata);

  params = (MYSQL_BIND *) malloc (sizeof (MYSQL_BIND) * num_cols);
  if (!params)
  {
    print_stmt_error (NULL, "Cannot allocate output parameters");
    return (1);
  }

  /* initialize parameter structures and bind to statement */
  memset (params, 0, sizeof (MYSQL_BIND) * num_cols);

  for (i = 0; i < num_cols; ++i)
  {
    params[i].buffer_type = fields[i].type;
    params[i].is_null = &is_null[i];

    if (fields[i].type != MYSQL_TYPE_LONG)
    {
      fprintf (stderr, "ERROR: unexpected type: %d.\n", fields[i].type);
      return (1);
    }
    params[i].buffer = (char *) &(int_data[i]);
    params[i].buffer_length = sizeof (int_data);
  }
  mysql_free_result (metadata); /* done with metadata, free it */

  if (mysql_stmt_bind_result (stmt, params))
  {
    print_stmt_error (stmt, "Cannot bind result to output buffers");
    return (1);
  }

  /* retrieve result set rows, display contents */
  while (1)
  {
    int status = mysql_stmt_fetch (stmt);
    if (status == 1 || status == MYSQL_NO_DATA)
      break;  /* no more rows */

    for (i = 0; i < num_cols; ++i)
    {
      printf (" val[%d] = ", i+1);
      if (params[i].buffer_type != MYSQL_TYPE_LONG)
        printf ("  unexpected type (%d)\n", params[i].buffer_type);
      else
      {
        if (*params[i].is_null)
          printf ("NULL;");
        else
          printf ("%ld;", (long) *((int *) params[i].buffer));
      }
    }
    printf ("\n");
  }

  free (params); /* done with output buffers, free them */
  return (0);
}
/* #@ _PROCESS_RESULT_SET_ */

/*
 * Process results produced by executing prepared CALL statement.
 */

/* #@ _PROCESS_CALL_RESULT_ */
static void process_call_result (MYSQL *conn, MYSQL_STMT *stmt)
{
int status;
int num_cols;

  /*
   * For each result, check number of columns.  If none, the result is
   * the final status packet and there is nothing to do. Otherwise,
   * fetch the result set.
   */
  do {
    if ((num_cols = mysql_stmt_field_count (stmt)) > 0)
    {
      /* announce whether result set contains parameters or data set */
      if (conn->server_status & SERVER_PS_OUT_PARAMS)
        printf ("OUT/INOUT parameter values:\n");
      else
        printf ("Statement result set values:\n");

      if (process_result_set (stmt, num_cols))
        break; /* some error occurred */
    }

    /* status is -1 = done, 0 = more results, >0 = error */
    status = mysql_stmt_next_result (stmt);
    if (status > 0)
      print_stmt_error (stmt, "Error checking for next result");
  } while (status == 0);
}
/* #@ _PROCESS_CALL_RESULT_ */

/*
 * Execute prepared CALL statement.
 *
 * Return zero for success and nonzero if an error occurred.
 */

/* #@ _EXEC_PREPARED_CALL_ */
static int exec_prepared_call (MYSQL_STMT *stmt)
{
MYSQL_BIND params[3];   /* parameter buffers */
int        int_data[3]; /* parameter values */
int        i;

  /* prepare CALL statement */
  if (mysql_stmt_prepare (stmt, "CALL grade_event_stats(?, ?, ?)", 31))
  {
    print_stmt_error (stmt, "Cannot prepare statement");
    return (1);
  }

  /* initialize parameter structures and bind to statement */
  memset (params, 0, sizeof (params));

  for (i = 0; i < 3; ++i)
  {
    params[i].buffer_type = MYSQL_TYPE_LONG;
    params[i].buffer = (char *) &int_data[i];
    params[i].length = 0;
    params[i].is_null = 0;
  }

  if (mysql_stmt_bind_param (stmt, params))
  {
    print_stmt_error (stmt, "Cannot bind parameters");
    return (1);
  }

  /* assign parameter values and execute statement */
  int_data[0]= 4;  /* p_event_id */
  int_data[1]= 0;  /* p_min (OUT param; initial value ignored by procedure */
  int_data[2]= 0;  /* p_min (OUT param; initial value ignored by procedure */

  if (mysql_stmt_execute (stmt))
  {
    print_stmt_error (stmt, "Cannot execute statement");
    return (1);
  }
  return (0);
}
/* #@ _EXEC_PREPARED_CALL_ */

int
main (int argc, char *argv[])
{
int        opt_err;
MYSQL      *conn;   /* pointer to connection handler */
MYSQL_STMT *stmt;   /* pointer to statement handler */

  MY_INIT (argv[0]);
  load_defaults ("my", client_groups, &argc, &argv);

  if ((opt_err = handle_options (&argc, &argv, my_opts, get_one_option)))
    exit (opt_err);

  /* solicit password if necessary */
  if (ask_password)
    opt_password = get_tty_password (NULL);

  /* get database name if present on command line */
  if (argc > 0)
  {
    opt_db_name = argv[0];
    --argc; ++argv;
  }

  /* initialize client library */
  if (mysql_library_init (0, NULL, NULL))
  {
    print_error (NULL, "mysql_library_init() failed");
    exit (1);
  }

  /* initialize connection handler */
  conn = mysql_init (NULL);
  if (conn == NULL)
  {
    print_error (NULL, "mysql_init() failed (probably out of memory)");
    exit (1);
  }

#ifdef HAVE_OPENSSL
  /* pass SSL information to client library */
  if (opt_use_ssl)
    mysql_ssl_set (conn, opt_ssl_key, opt_ssl_cert, opt_ssl_ca,
                   opt_ssl_capath, opt_ssl_cipher);
  mysql_options (conn,MYSQL_OPT_SSL_VERIFY_SERVER_CERT,
                 (char*)&opt_ssl_verify_server_cert);
#endif

  /* connect to server */
  if (mysql_real_connect (conn, opt_host_name, opt_user_name, opt_password,
      opt_db_name, opt_port_num, opt_socket_name, opt_flags) == NULL)
  {
    print_error (conn, "mysql_real_connect() failed");
    mysql_close (conn);
    exit (1);
  }

/* #@ _VERIFY_SERVER_VERSION_ */
  if (mysql_get_server_version (conn) < 50503)
  {
    print_error (NULL, "Prepared CALL requires MySQL 5.5.3 or higher");
    mysql_close (conn);
    exit (1);
  }
/* #@ _VERIFY_SERVER_VERSION_ */

  /* initialize statement handler, execute prepared CALL, close handler */
/* #@ _CALL_PROCEDURE_ */
  stmt = mysql_stmt_init (conn);
  if (!stmt)
    print_error (NULL, "Could not initialize statement handler");
  else
  {
    if (exec_prepared_call (stmt) == 0)
      process_call_result (conn, stmt);
    mysql_stmt_close (stmt);
  }
/* #@ _CALL_PROCEDURE_ */

  /* disconnect from server, terminate client library */
  mysql_close (conn);
  mysql_library_end ();
  exit (0);
}
