/*
 * binary.c - demonstrate how to load an image (binary data) into a table
 */

/* Usage: binary [db_name [file_name]] */

#include <my_global.h>
#include <my_sys.h>
#include <m_string.h>   /* for strdup() */
#include <mysql.h>
#include <my_getopt.h>

static char *opt_host_name = NULL;    /* server host (default=localhost) */
static char *opt_user_name = NULL;    /* username (default=login name) */
static char *opt_password = NULL;     /* password (default=none) */
static unsigned int opt_port_num = 0; /* port number (use built-in value) */
static char *opt_socket_name = NULL;  /* socket name (use built-in value) */
static char *opt_db_name = NULL;      /* database name (default=none) */
static unsigned int opt_flags = 0;    /* connection flags (none) */

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
  }
  return (0);
}

#include "load_image.c"

int
main (int argc, char *argv[])
{
int opt_err;
char *file_name = NULL;
FILE *f;

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

  /* get image file name if present on command line */
  if (argc > 0)
  {
    file_name = argv[0];
    --argc; ++argv;
  }
  if (!opt_db_name)
  {
    opt_db_name = "sampdb";
    printf ("No database named on command line; assuming sampdb\n");
  }
  /* this isn't really a "binary" file, but it'll do */
  if (!file_name)
  {
    file_name = "/etc/motd";
    printf ("No file named on command line; assuming /etc/motd\n");
  }
  if ((f = fopen (file_name, "r")) == NULL)
  {
    print_error (NULL, "Cannot open file");
    exit (1);
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

  /* connect to server */
  if (mysql_real_connect (conn, opt_host_name, opt_user_name, opt_password,
      opt_db_name, opt_port_num, opt_socket_name, opt_flags) == NULL)
  {
    print_error (conn, "mysql_real_connect() failed");
    mysql_close (conn);
    exit (1);
  }

  /*
   * Load file contents as image 1.  To make sure that works
   * drop any image 1 that might already exist first.
   */

  if (mysql_query (conn, "DELETE FROM picture WHERE pict_id = 1"))
  {
    print_error (conn, "DELETE statement failed");
  }
  else
  {
    if (load_image (conn, 1, f))
      print_error (conn, "Image loading failed");
  }

  /* disconnect from server, terminate client library */
  mysql_close (conn);
  mysql_library_end ();
  exit (0);
}
