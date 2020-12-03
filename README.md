# TestTaskLWC
Simple LWC for get object and field information.

1. open GIT Bush from folder where you will create new project.

2. use command:
 git clone https://github.com/AleksandrMazan/TestTaskLWC.git
 for get project from git
 
3. go to new folder:
  cd TestTaskLWC

4. set DevHub org:
  sfdx force:auth:web:login -d -a DevHub

5. After login page is opened in browser, use UserName: aleksandr.mazan.test.task@gmail.com Password: $ZW@%uVKnK6!0D4$z8j5

6. After successfully authorized create new scratch org: sfdx force:org:create -s -f config/project-scratch-def.json -a "NewScratch"

7. Deploy local data to scratch org: sfdx force:org:push

8. Open scratch org: sfdx force:org:open -u NewScratch

9. Open App Luncher and click by "Object_Info"

Warning: The tab display only for "System Admin"
