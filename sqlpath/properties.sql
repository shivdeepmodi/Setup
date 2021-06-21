column PROPERTY_NAME  heading 'Property Name'  format a30
column PROPERTY_VALUE heading 'Property Value' format a30
column DESCRIPTION    heading 'Description'    format a40

select PROPERTY_NAME,PROPERTY_VALUE,DESCRIPTION
  from database_properties;
clear columns