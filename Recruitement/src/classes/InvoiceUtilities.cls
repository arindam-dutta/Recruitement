Global with sharing class InvoiceUtilities {
    Webservice Static string renumberLineItems(string InvoiceName){
        Invoice_Statement__c invoice = [Select i.name, (Select Name from line_items__r Order by Name)
                             From Invoice_Statement__c i
                             Where i.Name = :InvoiceName LIMIT 1];
        
        Integer i = 1;
        for (Line_Item__c item : invoice.line_items__r){
            item.Name = String.valueOf(i);
            System.debug(item.Name);
            i++;
        }
        try {
            Database.update(invoice.Line_Items__r);
        }
        catch (DmlException e) 
        {
        return e.getMessage();
        }
    return 'Line items re-numbered successfully.';     
    }
}