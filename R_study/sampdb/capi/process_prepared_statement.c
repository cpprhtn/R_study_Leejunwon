/* #@ _INSERT_RECORDS_ */
static void
insert_rows (MYSQL_STMT *stmt)
{
char          *stmt_str = "INSERT INTO t (i,f,c,dt) VALUES(?,?,?,?)";
MYSQL_BIND    param[4];
int           my_int;
float         my_float;
char          my_str[26]; /* ctime() returns 26-character string */
MYSQL_TIME    my_datetime;
unsigned long my_str_length;
time_t        clock;
struct tm     *cur_time;
int           i;

  printf ("Inserting records...\n");

  if (mysql_stmt_prepare (stmt, stmt_str, strlen (stmt_str)) != 0)
  {
    print_stmt_error (stmt, "Could not prepare INSERT statement");
    return;
  }

  /*
   * zero the parameter structures, then perform all parameter
   * initialization that is constant and does not change for each row
   */

  memset ((void *) param, 0, sizeof (param));

  /* set up INT parameter */

  param[0].buffer_type = MYSQL_TYPE_LONG;
  param[0].buffer = (void *) &my_int;
  param[0].is_unsigned = 0;
  param[0].is_null = 0;
  /* buffer_length, length need not be set */

  /* set up FLOAT parameter */

  param[1].buffer_type = MYSQL_TYPE_FLOAT;
  param[1].buffer = (void *) &my_float;
  param[1].is_null = 0;
  /* is_unsigned, buffer_length, length need not be set */

  /* set up CHAR parameter */

  param[2].buffer_type = MYSQL_TYPE_STRING;
  param[2].buffer = (void *) my_str;
  param[2].buffer_length = sizeof (my_str);
  param[2].is_null = 0;
  /* is_unsigned need not be set, length is set later */

  /* set up DATETIME parameter */

  param[3].buffer_type = MYSQL_TYPE_DATETIME;
  param[3].buffer = (void *) &my_datetime;
  param[3].is_null = 0;
  /* is_unsigned, buffer_length, length need not be set */

  if (mysql_stmt_bind_param (stmt, param) != 0)
  {
    print_stmt_error (stmt, "Could not bind parameters for INSERT");
    return;
  }

  for (i = 1; i <= 5; i++)
  {
    printf ("Inserting record %d...\n", i);

    (void) time (&clock); /* get current time */

    /* set the variables that are associated with each parameter */

    /* param[0]: set my_int value */
    my_int = i;

    /* param[1]: set my_float value */
    my_float = (float) i;

    /* param[2]: set my_str to current ctime() string value */
    /* and set length to point to var that indicates my_str length */
    (void) strcpy (my_str, ctime (&clock));
    my_str[24] = '\0';  /* chop off trailing newline */
    my_str_length = strlen (my_str);
    param[2].length = &my_str_length;

    /* param[3]: set my_datetime to current date and time components */
    cur_time = localtime (&clock);
    my_datetime.year = cur_time->tm_year + 1900;
    my_datetime.month = cur_time->tm_mon + 1;
    my_datetime.day = cur_time->tm_mday;
    my_datetime.hour = cur_time->tm_hour;
    my_datetime.minute = cur_time->tm_min;
    my_datetime.second = cur_time->tm_sec;
    my_datetime.second_part = 0;
    my_datetime.neg = 0;

    if (mysql_stmt_execute (stmt) != 0)
    {
      print_stmt_error (stmt, "Could not execute statement");
      return;
    }

    sleep (1);  /* pause briefly (to let the time change) */
  }
}
/* #@ _INSERT_RECORDS_ */


/* #@ _SELECT_RECORDS_ */
static void
select_rows (MYSQL_STMT *stmt)
{
char          *stmt_str = "SELECT i, f, c, dt FROM t";
MYSQL_BIND    param[4];
int           my_int;
float         my_float;
char          my_str[24];
unsigned long my_str_length;
MYSQL_TIME    my_datetime;
my_bool       is_null[4];

  printf ("Retrieving records...\n");

  if (mysql_stmt_prepare (stmt, stmt_str, strlen (stmt_str)) != 0)
  {
    print_stmt_error (stmt, "Could not prepare SELECT statement");
    return;
  }

  if (mysql_stmt_field_count (stmt) != 4)
  {
    print_stmt_error (stmt, "Unexpected column count from SELECT");
    return;
  }

  /*
   * initialize the result column structures
   */

  memset ((void *) param, 0, sizeof (param)); /* zero the structures */

  /* set up INT parameter */

  param[0].buffer_type = MYSQL_TYPE_LONG;
  param[0].buffer = (void *) &my_int;
  param[0].is_unsigned = 0;
  param[0].is_null = &is_null[0];
  /* buffer_length, length need not be set */

  /* set up FLOAT parameter */

  param[1].buffer_type = MYSQL_TYPE_FLOAT;
  param[1].buffer = (void *) &my_float;
  param[1].is_null = &is_null[1];
  /* is_unsigned, buffer_length, length need not be set */

  /* set up CHAR parameter */

  param[2].buffer_type = MYSQL_TYPE_STRING;
  param[2].buffer = (void *) my_str;
  param[2].buffer_length = sizeof (my_str);
  param[2].length = &my_str_length;
  param[2].is_null = &is_null[2];
  /* is_unsigned need not be set */

  /* set up DATETIME parameter */

  param[3].buffer_type = MYSQL_TYPE_DATETIME;
  param[3].buffer = (void *) &my_datetime;
  param[3].is_null = &is_null[3];
  /* is_unsigned, buffer_length, length need not be set */

  if (mysql_stmt_bind_result (stmt, param) != 0)
  {
    print_stmt_error (stmt, "Could not bind parameters for SELECT");
    return;
  }

  if (mysql_stmt_execute (stmt) != 0)
  {
    print_stmt_error (stmt, "Could not execute SELECT");
    return;
  }

  /*
   * fetch result set into client memory; this is optional, but it
   * enables mysql_stmt_num_rows() to be called to determine the
   * number of rows in the result set.
   */

  if (mysql_stmt_store_result (stmt) != 0)
  {
    print_stmt_error (stmt, "Could not buffer result set");
    return;
  }
  else
  {
    /* mysql_stmt_store_result() makes row count available */
    printf ("Number of rows retrieved: %lu\n",
            (unsigned long) mysql_stmt_num_rows (stmt));
  }

  while (mysql_stmt_fetch (stmt) == 0)  /* fetch each row */
  {
    /* display row values */
    printf ("%d  ", my_int);
    printf ("%.2f  ", my_float);
    printf ("%*.*s  ", (int) my_str_length, (int) my_str_length, my_str);
    printf ("%04d-%02d-%02d %02d:%02d:%02d\n",
            my_datetime.year,
            my_datetime.month,
            my_datetime.day,
            my_datetime.hour,
            my_datetime.minute,
            my_datetime.second);
  }

  mysql_stmt_free_result (stmt);      /* deallocate result set */
}
/* #@ _SELECT_RECORDS_ */

/* #@ _PROCESS_PREPARED_STATEMENTS_ */
void
process_prepared_statements (MYSQL *conn)
{
MYSQL_STMT *stmt;
char       *use_stmt = "USE sampdb";
char       *drop_stmt = "DROP TABLE IF EXISTS t";
char       *create_stmt =
  "CREATE TABLE t (i INT, f FLOAT, c CHAR(24), dt DATETIME)";

  /* select database and create test table */

  if (mysql_query (conn, use_stmt) != 0
    || mysql_query (conn, drop_stmt) != 0
    || mysql_query (conn, create_stmt) != 0)
  {
    print_error (conn, "Could not set up test table");
    return;
  }

  stmt = mysql_stmt_init (conn);  /* allocate statement handler */
  if (stmt == NULL)
  {
    print_error (conn, "Could not initialize statement handler");
    return;
  }

  /* insert and retrieve some records */
  insert_rows (stmt);
  select_rows (stmt);

  mysql_stmt_close (stmt);       /* deallocate statement handler */
}
/* #@ _PROCESS_PREPARED_STATEMENTS_ */
