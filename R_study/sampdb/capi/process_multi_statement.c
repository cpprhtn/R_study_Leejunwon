void
process_multi_statement (MYSQL *conn, char *stmt_str)
{
MYSQL_RES *res_set;
int       status;
int       keep_going = 1;

  if (mysql_query (conn, stmt_str) != 0)  /* the statement(s) failed */
  {
    print_error (conn, "Could not execute statement(s)");
    return;
  }

  /* the statement(s) succeeded; enter result-retrieval loop */
  do {
    /* determine whether current statement returned data */
    res_set = mysql_store_result (conn);
    if (res_set)      /* a result set was returned */
    {
      /* process rows and free the result set */
      process_result_set (conn, res_set);
      mysql_free_result (res_set);
    }
    else              /* no result set was returned */
    {
      /*
       * does the lack of a result set mean that the statement didn't
       * return one, or that it should have but an error occurred?
       */
      if (mysql_field_count (conn) == 0)
      {
        /*
         * statement generated no result set (it was not a SELECT,
         * SHOW, DESCRIBE, etc.); just report rows-affected value.
         */
        printf ("Number of rows affected: %lu\n",
                (unsigned long) mysql_affected_rows (conn));
      }
      else  /* an error occurred */
      {
        print_error (conn, "Could not retrieve result set");
        keep_going = 0;
      }
    }
    /* determine whether more results exist */
    /* 0 = yes, -1 = no, >0 = error */
    status = mysql_next_result (conn);
    if (status != 0)    /* no more results, or an error occurred */
    {
      keep_going = 0;
      if (status > 0)   /* error */
        print_error (conn, "Could not execute statement");
    }
  } while (keep_going);
}
