public with sharing class ProductController {
    public String cvversion {get; set;}
    public Boolean ShowpageBlockFlag{get; set;}

    public void show (){
        // String id = ApexPages.currentPage().getParameters().get('AttachmentID');
        try {
            
            System.debug('Hi');
            ContentDocumentLink cdl = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: '0019D00000Z0eqUQAR'LIMIT 1];
            ContentVersion att = [SELECT Id, ContentBodyId,FileExtension, ContentUrl, VersionDataUrl, VersionData FROM ContentVersion WHERE ContentDocumentId =: cdl.ContentDocumentId LIMIT 1];
            cvversion = EncodingUtil.Base64Encode(att.VersionData);
            System.debug('Nimit'+att);
            System.debug(cvversion);
            ShowpageBlockFlag = true;
        } catch (Exception e) {
            System.debug(e);
        }
}

    public static void scene1(List<Product2> productlist){
        Map<Id, Integer> readyproductitemprice = new Map<Id, Integer>();
        Map<Id, Product2> Notreadyproduct = new Map<Id, Product2>();
        Map<Id, Integer> extracount = new Map<Id, Integer>();
        Decimal division = 0;
        for (Product2 product : productlist) {
            division = product.Product_Price__c/product.Product_Item_Number__c;
            if( division.stripTrailingZeros().scale() == 0){
                readyproductitemprice.put(product.Id, division.intValue());
            } else {
                Notreadyproduct.put(product.Id, product);
            }
        }
        division = 0;
      
        for (Id productId : Notreadyproduct.keyset()) {
            Integer i = 0;
            Boolean checkdivision = false;

            while (checkdivision == false) {
                i += 1;
                division = Notreadyproduct.get(productId).Product_Price__c + i/Notreadyproduct.get(productId).Product_Item_Number__c;

                if( division.stripTrailingZeros().scale() == 0){
                    readyproductitemprice.put(productId, division.intValue());
                    extracount.put(productId, i);
                    checkdivision = true;
                }
            }
        }
        
        List<ProductItem> productitemlist = new List<ProductItem>();
        for (Product2 product : productlist) {
            for(integer i = 0; i < product.Product_Item_Number__c; i++){
                if (extracount.get(product.Id) != null) {
                    if (i == product.Product_Item_Number__c) {
                        productitemlist.add(new ProductItem( Product2Id = product.Id, QuantityOnHand = 2, Price__c = product.Product_Price__c - extracount.get(product.Id),LocationId ='1319D000000E9NWQA0'));
                    } else {
                        productitemlist.add(new ProductItem( Product2Id = product.Id, QuantityOnHand = 2, Price__c = product.Product_Price__c,LocationId ='1319D000000E9NWQA0'));
                    }
                } else {
                    productitemlist.add(new ProductItem( Product2Id = product.Id, QuantityOnHand = 2, Price__c = product.Product_Price__c,LocationId ='1319D000000E9NWQA0'));
                }
            }
        }
        insert productitemlist;
    }

    

    

  }