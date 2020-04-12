/*
 * process a result set, displaying the metadata rather than the data
 */

void
process_result_set (MYSQL *conn, MYSQL_RES *res_set)
{
MYSQL_ROW   row;
MYSQL_FIELD   *field;
unsigned long *length;
unsigned int  i;

  for (i = 0; i < mysql_num_fields (res_set); i++)
  {
    field = mysql_fetch_field (res_set);
    printf ("----- %u -----\n", i);
    printf ("            name: %s\n", field->name);
    printf ("        org_name: %s\n", field->org_name);
    printf ("           table: %s\n", field->table ? field->table : "NULL");
    printf ("       org_table: %s\n", field->org_table);
    printf ("              db: %s\n", field->db);
    printf ("         catalog: %s\n", field->catalog);
    printf ("             def: %s\n", field->def ? field->def : "NULL");
    printf ("          length: %lu\n", field->length);
    printf ("      max_length: %lu\n", field->max_length);
    printf ("     name_length: %u\n", field->name_length);
    printf (" org_name_length: %u\n", field->org_name_length);
    printf ("    table_length: %u\n", field->table_length);
    printf ("org_table_length: %u\n", field->org_table_length);
    printf ("       db_length: %u\n", field->db_length);
    printf ("   catalog_length: %u\n", field->catalog_length);
    printf ("       def_length: %u\n", field->def_length);
    printf ("            flags: %x\n", field->flags);
    printf ("         decimals: %u\n", field->decimals);
    printf ("        charsetnr: %u\n", field->charsetnr);
    printf ("             type: %u\n", field->type);
    printf ("           IS_NUM: %d\n", IS_NUM(field->type));
    printf ("      IS_NOT_NULL: %d\n", IS_NOT_NULL(field->flags));
  }
}
