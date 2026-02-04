
import BaseController from "./BaseController";
import { FilterBar$ClearEvent, FilterBar$SearchEvent } from "sap/ui/comp/filterbar/FilterBar";
import Control from "sap/ui/core/Control";
import Input, { Input$ValueHelpRequestEvent } from "sap/m/Input";
import FilterOperator from "sap/ui/model/FilterOperator";
import Filter from "sap/ui/model/Filter";
import Table from "sap/m/Table";
import JSONModel from "sap/ui/model/json/JSONModel";
//import * as XLSX from 'xlsx';
import SelectDialog from "sap/m/SelectDialog";
import Fragment from "sap/ui/core/Fragment";
import View from "sap/ui/core/mvc/View";
import Event from "sap/ui/base/Event";
import MultiInput from "sap/m/MultiInput";
import StandardListItem from "sap/m/StandardListItem";
import Token from "sap/m/Token";
import ColumnListItem from "sap/m/ColumnListItem";
import DateRangeSelection from "sap/m/DateRangeSelection";
import MultiComboBox from "sap/m/MultiComboBox";
import ODataListBinding from "sap/ui/model/odata/v2/ODataListBinding";


/**
 * @namespace com.logaligroup.employees.controller
 */
export default class Master extends BaseController {

    _pValueHelpDialog : SelectDialog;

    countryKeys: string[] = [];

    /*eslint-disable @typescript-eslint/no-empty-function*/

    public onInit(): void {
        this.loadView();
    }

    private loadView () : void {
        const oViewModel = new JSONModel({
            availableRegions: [],
            availableCities: []
        });
        this.getView()?.setModel(oViewModel, "view");
    }

    public onSearchPress (event : FilterBar$SearchEvent ) : void {

        const controls = event.getParameter("selectionSet") as Control[];
        const oEmployeeControl = controls[0] as Input;
        const oCountryControl = controls[1] as MultiInput;
        const oRegionControl = controls[2] as MultiComboBox;
        const oCityControl = controls[3] as MultiComboBox;
        const oBirthDateControl = controls[4] as DateRangeSelection;
        const oTitleControl = controls[5] as MultiComboBox;
        const oStatusControl = controls[6] as MultiComboBox;

        let filters: Filter[] = [];

        let sInput = oEmployeeControl.getValue() as string;
        if (sInput) {
            filters.push(new Filter({
                filters: [
                    new Filter("FirstName", FilterOperator.Contains, sInput),
                    new Filter("LastName", FilterOperator.Contains, sInput),
                    new Filter("FullName", FilterOperator.Contains, sInput)
                ],
                and: false
            }));
        }

        const createFilterForAssociation = (aKeys: string[], sPath: string) => {
            if (aKeys.length > 0) {
                const aAssociationFilters = aKeys.map(sKey => new Filter(sPath, FilterOperator.EQ, sKey));
                filters.push(new Filter({ filters: aAssociationFilters, and: false }));
            }
        };
        
        createFilterForAssociation(oCountryControl.getTokens().map(token => token.getKey()), "Country_ID");
        createFilterForAssociation(oRegionControl.getSelectedKeys(), "Region_ID");
        createFilterForAssociation(oCityControl.getSelectedKeys(), "City_ID");
        createFilterForAssociation(oTitleControl.getSelectedKeys(), "Title_ID");
        createFilterForAssociation(oStatusControl.getSelectedKeys(), "Status_Code");

        const dStartDate = oBirthDateControl.getDateValue();
        const dEndDate = oBirthDateControl.getSecondDateValue();
        if (dStartDate && dEndDate) {
            filters.push(new Filter("BirthDate", FilterOperator.BT, dStartDate.toISOString(), dEndDate.toISOString()));
        }

    
        this.applyFilters(filters);
    }

    private applyFilters (filters : Filter[]) : void {
        let table = this.byId("table") as Table;
        let binding = table.getBinding("items") as ODataListBinding;
        binding.filter(new Filter({
            filters: filters,
            and: true
        }));
    } 

    public onClearPress (event: FilterBar$ClearEvent) : void {
        
        const controls = event.getParameter("selectionSet") as Control[];
        const oEmployeeControl = controls[0] as Input;
        const oCountryControl = controls[1] as MultiInput;
        const oRegionControl = controls[2] as MultiComboBox;
        const oCityControl = controls[3] as MultiComboBox;
        const oBirthDateControl = controls[4] as DateRangeSelection;
        const oTitleControl = controls[5] as MultiComboBox;
        const oStatusControl = controls[6] as MultiComboBox;

        oEmployeeControl.setValue("");
        oCountryControl.removeAllTokens();
        oRegionControl.clearSelection();
        oCityControl.clearSelection();
        oBirthDateControl.setDateValue(null);
        oBirthDateControl.setSecondDateValue(null);
        oTitleControl.clearSelection();
        oStatusControl.clearSelection();

        this.countryKeys = [];
        this._updateRegionFilter(); 

        this.applyFilters([]);    
    }

    // public onDownloadPress () : void {

	// 		const oTable = this.byId("table") as Table;
	// 		const oRowBinding = oTable.getBinding("items") as ListBinding;
	// 		let aDataToExport: any[] = [];
			
	// 		oRowBinding.getContexts().forEach(oContext => {
	// 			const oEmployee = oContext.getObject() as any;
				
	// 			aDataToExport.push({
	// 				"ID": oEmployee.EmployeeID,
	// 				"Nombre Completo": `${oEmployee.FirstName} ${oEmployee.LastName}`,
	// 				"País": oEmployee.Country,
	// 				"Ciudad": oEmployee.City,
	// 				"Código Postal": oEmployee.PostalCode
	// 			});
	// 		});
			
	// 		if (aDataToExport.length === 0) {
	// 			return;
	// 		}
			
	// 		const oWorkSheet = XLSX.utils.json_to_sheet(aDataToExport);
	// 		const oWorkBook = XLSX.utils.book_new();
	// 		XLSX.utils.book_append_sheet(oWorkBook, oWorkSheet, "Empleados");
			
	// 		XLSX.writeFile(oWorkBook, "Listado de Empleados.xlsx");
    // }

    public async onValueHelpRequest (event : Input$ValueHelpRequestEvent) : Promise<void> {

        var sInputValue = event.getSource().getValue(),
            oView = this.getView() as View;

            this._pValueHelpDialog ??= await Fragment.load({
                id: oView.getId(),
                name: "com.logaligroup.employees.fragment.ValueHelpDialog",
                controller: this
            }) as SelectDialog;

            oView.addDependent(this._pValueHelpDialog);
            let binding = this._pValueHelpDialog.getBinding("items") as ODataListBinding;
            let filters = [];
                filters.push(new Filter("Country", FilterOperator.Contains, sInputValue));
                binding.filter(filters);

            this._pValueHelpDialog.open(sInputValue);
    }

    public onTokenUpdate(event: Event): void {
        
        const params = event.getParameters() as any;
        const sType = params.type;

        if (sType === "added") {
            const aAddedTokens = params.addedTokens as Token[];
            aAddedTokens.forEach(token => {
                if (!this.countryKeys.includes(token.getKey())) {
                    this.countryKeys.push(token.getKey());
                }
            });
        } else if (sType === "removed") {
            const aRemovedTokens = params.removedTokens as Token[];
            const aRemovedKeys = aRemovedTokens.map(token => token.getKey());
            this.countryKeys = this.countryKeys.filter(sKey => !aRemovedKeys.includes(sKey));
        }

        this._updateRegionFilter();
    }

    public onValueHelpSearch(event: Event): void {
        const sValue = (event.getParameters() as any).value as string;
        const oFilter = new Filter("Country", FilterOperator.Contains, sValue);
        const oSelectDialog = event.getSource() as SelectDialog;
        const oBinding = oSelectDialog.getBinding("items") as ODataListBinding;
        oBinding.filter([oFilter]);
    }

    public onCountryValueHelpConfirm (event: Event) : void {

        const oMultiInput = this.byId("inputCountries") as MultiInput;
        const aSelectedItems = (event.getParameters() as any).selectedItems as StandardListItem[];

        oMultiInput.removeAllTokens();

        if (aSelectedItems && aSelectedItems.length > 0) {
            aSelectedItems.forEach((oItem) => {
                oMultiInput.addToken(new Token({
                    key: oItem.data("key"),
                    text: oItem.getTitle()
                }));
            });
        }

        this._updateRegionFilter();
    }

    public onCountryValueHelpCancel(event: Event): void {
    }

    private _updateRegionFilter(): void {

        const oCountryInput = this.byId("inputCountries") as MultiInput;
        const mcbRegion = this.byId("mcbRegion") as MultiComboBox;
        const mcbCity = this.byId("mcbCity") as MultiComboBox;

        mcbRegion.clearSelection();
        mcbCity.clearSelection();
        mcbRegion.setEnabled(false);
        mcbCity.setEnabled(false);

        const aSelectedCountryIDs = oCountryInput.getTokens().map(token => token.getKey());
        console.log(aSelectedCountryIDs);
            
            const oRegionBinding = mcbRegion.getBinding("items") as ODataListBinding;
            const oCityBinding = mcbCity.getBinding("items") as ODataListBinding;

            oCityBinding.filter([]);

            if (aSelectedCountryIDs.length > 0) {
                const aCountryFilters = aSelectedCountryIDs.map(sID => new Filter("Country_ID", FilterOperator.EQ, sID));
                console.log(aCountryFilters);
                oRegionBinding.filter(new Filter({
                    filters: aCountryFilters,
                    and: false
                }));
                mcbRegion.setEnabled(true);
            } else {
                oRegionBinding.filter([]);
            }
    }

    public onRegionSelectionChange(): void {
        const mcbRegion = this.byId("mcbRegion") as MultiComboBox;
        const mcbCity = this.byId("mcbCity") as MultiComboBox;

        const aSelectedRegionKeys = mcbRegion.getSelectedKeys();

        mcbCity.clearSelection();
        mcbCity.setEnabled(false);

        const oCityBinding = mcbCity.getBinding("items") as ODataListBinding;

        if (aSelectedRegionKeys.length > 0) {

            const aRegionFilters = aSelectedRegionKeys.map(sKey => new Filter("Region_ID", FilterOperator.EQ, sKey));
            
            oCityBinding.filter(new Filter({
                filters: aRegionFilters,
                and: false
            }));
            mcbCity.setEnabled(true);
        } else {
            oCityBinding.filter([]);
        }
    }

    public onNavToDetails (event : Event) : void {

        let item = event.getSource() as ColumnListItem;
        let bindingContext = item.getBindingContext();
        let id = bindingContext?.getProperty("ID");

        let viewModel = this.getModel("viewContainer") as JSONModel;
        viewModel.setProperty("/layout","TwoColumnsMidExpanded");

        let router = this.getRouter();
        router.navTo("RouteDetails", {
            key:  id
        });
    }
}