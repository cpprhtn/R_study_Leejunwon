void
summary_stats (MYSQL_RES *res_set, unsigned int col_num)
{
MYSQL_FIELD   *field;
MYSQL_ROW     row;
unsigned int  n, missing;
double        val, sum, sum_squares, var;

  /* verify data requirements: column must be in range and numeric */
  if (col_num < 0 || col_num >= mysql_num_fields (res_set))
  {
    print_error (NULL, "illegal column number");
    return;
  }
  mysql_field_seek (res_set, col_num);
  field = mysql_fetch_field (res_set);
  if (!IS_NUM (field->type))
  {
    print_error (NULL, "column is not numeric");
    return;
  }

  /* calculate summary statistics */

  n = 0;
  missing = 0;
  sum = 0;
  sum_squares = 0;

  mysql_data_seek (res_set, 0);
  while ((row = mysql_fetch_row (res_set)) != NULL)
  {
    if (row[col_num] == NULL)
      missing++;
    else
    {
      n++;
      val = atof (row[col_num]);  /* convert string to number */
      sum += val;
      sum_squares += val * val;
    }
  }
  if (n == 0)
    printf ("No observations\n");
  else
  {
    printf ("Number of observations: %u\n", n);
    printf ("Missing observations: %u\n", missing);
    printf ("Sum: %g\n", sum);
    printf ("Mean: %g\n", sum / n);
    printf ("Sum of squares: %g\n", sum_squares);
    var = ((n * sum_squares) - (sum * sum)) / (n * (n - 1));
    printf ("Variance: %g\n", var);
    printf ("Standard deviation: %g\n", sqrt (var));
  }
}
