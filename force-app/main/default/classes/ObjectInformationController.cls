/**
 * Created by Aleksandr Mazan on 26-Nov-20.
 */

public with sharing class ObjectInformationController {

    public class ObjectSelectWrapper implements Comparable {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public ObjectSelectWrapper(String objectLabel, String objectApiName) {
            this.label = objectLabel;
            this.value = objectApiName;
        }

        public Integer compareTo(Object objToCompare) {
            return label.compareTo(((ObjectSelectWrapper)objToCompare).label);
        }
}

    public class ObjectInformation {
        @AuraEnabled public  Map <String, String> generalInfo;
        @AuraEnabled public List<ObjectInformationController.ObjectFieldInformation> fieldsInformation;

    }

    public class ObjectFieldInformation {
        @AuraEnabled public String fieldType;
        @AuraEnabled public String label;
        @AuraEnabled public String name;
        @AuraEnabled public String relationshipName;
        @AuraEnabled public Boolean isAccessible;
        @AuraEnabled public Boolean isCreateable;
        @AuraEnabled public Boolean isUpdateable;
        @AuraEnabled public Boolean isUnique;
        @AuraEnabled public Boolean isCustom;
        @AuraEnabled public Boolean isExternalID;

        public ObjectFieldInformation(Schema.DescribeFieldResult fieldMetaData) {
            this.fieldType = String.valueOf(fieldMetaData.getType());
            this.label = fieldMetaData.getLabel();
            this.name = fieldMetaData.getName();
            this.relationshipName = fieldMetaData.getRelationshipName();
            this.isAccessible = fieldMetaData.isAccessible();
            this.isCreateable = fieldMetaData.isCreateable();
            this.isUpdateable = fieldMetaData.isUpdateable();
            this.isUnique = fieldMetaData.isUnique();
            this.isCustom = fieldMetaData.isCustom();
            this.isExternalID = fieldMetaData.isExternalID();
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ObjectInformationController.ObjectSelectWrapper> getListObjects() {
        Map<String, SObjectType> objectNames = Schema.getGlobalDescribe();
        List<ObjectInformationController.ObjectSelectWrapper> objectSelectList = new List<ObjectInformationController.ObjectSelectWrapper>();
        for (String key : objectNames.keySet()) {
            if(isAccessObject(String.valueOf(objectNames.get(key)))) {
                objectSelectList.add(new ObjectInformationController.ObjectSelectWrapper(String.valueOf(objectNames.get(key)), key));
            }
        }
        objectSelectList.sort();
        System.debug(objectSelectList);
        return objectSelectList;
    }

    private static Boolean isAccessObject(String sObjectApiName) {
        return Schema.getGlobalDescribe().get(sObjectApiName).getDescribe().isAccessible();
    }

    @AuraEnabled
    public static ObjectInformationController.ObjectInformation getSObjectDescribe(String sObjectApiName) {
        try {
            Schema.DescribeSObjectResult sObjectMetaData = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe();
            Map<String, Schema.SobjectField> fmap = sObjectMetaData.fields.getMap();
            ObjectInformationController.ObjectInformation objectInfo = new ObjectInformationController.ObjectInformation();
            List<ObjectInformationController.ObjectFieldInformation> fieldsInformation = new List<ObjectInformationController.ObjectFieldInformation>();
            for (Schema.SobjectField fieldInfo : fmap.values()) {
                fieldsInformation.add(new ObjectInformationController.ObjectFieldInformation(fieldInfo.getDescribe()));
            }
            objectInfo.generalInfo = getGeneralSObjectInfo(sObjectMetaData);
            objectInfo.fieldsInformation = fieldsInformation;
            return objectInfo;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    private static Map<String, String> getGeneralSObjectInfo(Schema.DescribeSObjectResult SObjectMetaData) {
        return new Map<String, String> {
                System.Label.Label => SObjectMetaData.getLabel(),
                System.Label.SObjectType => String.valueOf(SObjectMetaData.getSObjectType()),
                System.Label.Key_prefix => SObjectMetaData.getKeyPrefix(),
                System.Label.IsAccessible => String.valueOf(SObjectMetaData.isAccessible()),
                System.Label.IsCreateable => String.valueOf(SObjectMetaData.isCreateable()),
                System.Label.IsUpdateable => String.valueOf(SObjectMetaData.isUndeletable()),
                System.Label.IsDeletable => String.valueOf(SObjectMetaData.isDeletable()),
                System.Label.IsQueryable => String.valueOf(SObjectMetaData.isQueryable()),
                System.Label.IsCustom => String.valueOf(SObjectMetaData.isCustom())
        };
    }
}