/**
 * Created by Aleksandr Mazan on 29-Nov-20.
 */

@IsTest
public with sharing class ObjectInformationControllerTest {

    @IsTest
    public static void getListObjectsTest(){
        List<ObjectInformationController.ObjectSelectWrapper> listSObjects = ObjectInformationController.getListObjects();
    }

    @IsTest
    public static void getSObjectDescribeTest(){
        Map<String, SObjectType> objectNames = Schema.getGlobalDescribe();
        ObjectInformationController.ObjectInformation objectInfo = ObjectInformationController.getSObjectDescribe(String.valueOf(new List<String>(objectNames.keySet())[0]));
    }
}