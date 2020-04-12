int
load_image (MYSQL *conn, int id, FILE *f)
{
char          stmt_buf[1024*1024], buf[1024*10], *p;
unsigned long from_len;
int           status;

  /* begin creating an INSERT statement, adding the id value */
  sprintf (stmt_buf,
           "INSERT INTO picture (pict_id,pict_data) VALUES (%d,'",
           id);
  p = stmt_buf + strlen (stmt_buf);
  /* read data from file in chunks, encode each */
  /* chunk, and add to end of statement */
  while ((from_len = fread (buf, 1, sizeof (buf), f)) > 0)
  {
    /* don't overrun end of statement buffer! */
    if (p + (2*from_len) + 3 > stmt_buf + sizeof (stmt_buf))
    {
      print_error (NULL, "image is too big");
      return (1);
    }
    p += mysql_real_escape_string (conn, p, buf, from_len);
  }
  *p++ = '\'';
  *p++ = ')';
  status = mysql_real_query (conn, stmt_buf, (unsigned long) (p - stmt_buf));
  return (status);
}
