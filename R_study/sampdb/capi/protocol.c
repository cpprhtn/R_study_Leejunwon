/*
 * protocol.c - simple interactive statement-execution program
 *
 * (similar to exec_stmt.c, but supports the --protocol option, and
 * --shared-memory-base-name on Windows.)
 */

#include <my_global.h>
#include <my_sys.h>
#include <m_string.h>   /* for strdup() */
#include <mysql.h>
#include <my_getopt.h>

enum options_client
{
  OPT_MYSQL_PROTOCOL,
  OPT_SHARED_MEMORY_BASE_NAME
};

static char *opt_host_name = NULL;    /* server host (default=localhost) */
static char *opt_user_name = NULL;    /* username (default=login name) */
static char *opt_password = NULL;     /* password (default=none) */
static unsigned int opt_port_num = 0; /* port number (use built-in value) */
static char *opt_socket_name = NULL;  /* socket name (use built-in value) */
static char *opt_db_name = NULL;      /* database name (default=none) */
static unsigned int opt_flags = 0;    /* connection flags (none) */
static unsigned int opt_protocol = 0; /* connection protocol (unspecified) */
#ifdef HAVE_SMEM
static char *opt_shared_memory_base_name = NULL;
#endif

static int ask_password = 0;          /* whether to solicit password */

static MYSQL *conn;                   /* pointer to connection handler */

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
  {"protocol", OPT_MYSQL_PROTOCOL,
  "Connection protocol (tcp, socket, pipe, memory",
  NULL, NULL, NULL,
  GET_STR, REQUIRED_ARG, 0, 0, 0, 0, 0, 0},
#ifdef HAVE_SMEM
  {"shared-memory-base-name", OPT_SHARED_MEMORY_BASE_NAME,
  "Base name of shared memory",
  (uchar **) &opt_shared_memory_base_name,
  (uchar **) &opt_shared_memory_base_name, NULL,
  GET_STR, REQUIRED_ARG, 0, 0, 0, 0, 0, 0},
#endif
  {"socket", 'S', "Socket path",
  (uchar **) &opt_socket_name, NULL, NULL,
  GET_STR, REQUIRED_ARG, 0, 0, 0, 0, 0, 0},
  {"user", 'u', "User name",
  (uchar **) &opt_user_name, NULL, NULL,
  GET_STR, REQUIRED_ARG, 0, 0, 0, 0, 0, 0},
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
  case OPT_MYSQL_PROTOCOL:
    opt_protocol = find_type (argument, &sql_protocol_typelib, 0);
    if (opt_protocol <= 0)
    {
      print_error (NULL, "Unknown option to --protocol:");
      print_error (NULL, argument);
      exit (1);
    }
    break;
  }
  return (0);
}

#include "process_result_set.c"

#include "process_statement.c"

int
main (int argc, char *argv[])
{
int opt_err;

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

  if (opt_protocol)
    mysql_options (conn, MYSQL_OPT_PROTOCOL, (char*)&opt_protocol);
#ifdef HAVE_SMEM
  if (opt_shared_memory_base_name)
    mysql_options (conn, MYSQL_SHARED_MEMORY_BASE_NAME,
            opt_shared_memory_base_name);
#endif

  /* connect to server */
  if (mysql_real_connect (conn, opt_host_name, opt_user_name, opt_password,
      opt_db_name, opt_port_num, opt_socket_name, opt_flags) == NULL)
  {
    print_error (conn, "mysql_real_connect() failed");
    mysql_close (conn);
    exit (1);
  }

  while (1)
  {
    char  buf[10000];

    fprintf (stderr, "query> ");          /* print prompt */
    if (fgets (buf, sizeof (buf), stdin) == NULL) /* read statement */
      break;
    if (strcmp (buf, "quit\n") == 0 || strcmp (buf, "\\q\n") == 0)
      break;
    process_statement (conn, buf);          /* execute it */
  }

  /* disconnect from server, terminate client library */
  mysql_close (conn);
  mysql_library_end ();
  exit (0);
}
