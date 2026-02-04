using {com.logaligroup as entities} from '../db/schema';

service Employees {

    entity Employees as projection on entities.Employees;
    entity Orders as projection on entities.Orders;
    // Value Helps
    @readonly
    entity VH_Countries as projection on entities.Countries order by Code;
    @readonly
    entity VH_Regions as projection on entities.Regions;
    @readonly
    entity VH_Cities as projection on entities.Cities;
    @readonly
    entity VH_Titles as projection on entities.Titles;
    @readonly
    entity VH_Status as projection on entities.Status;
    @readonly
    entity VH_Departments as projection on entities.Departments;
}