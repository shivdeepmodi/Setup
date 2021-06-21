set long 1000000 
select xmltransform(dbms_qopatch.get_opatch_install_info, dbms_qopatch.get_opatch_xslt) "Home and Inventory" from dual;
