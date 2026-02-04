import { Route$PatternMatchedEvent } from "sap/ui/core/routing/Route";
import BaseController from "./BaseController";
import View from "sap/ui/core/mvc/View";
import JSONModel from "sap/ui/model/json/JSONModel";
import Panel from "sap/m/Panel";
/**
 * @namespace com.logaligroup.employees
 */

export default class Container extends BaseController {


    panel: Panel;

    private removeAllContent(): void {
        const panel = this.byId("tableIncidence") as Panel;
        panel.removeAllContent();
    }

    public onInit(): void | undefined {
        const router = this.getRouter();
        router.getRoute("RouteDetails")?.attachPatternMatched(this.onBindingContext.bind(this));
    }

    private onBindingContext(event: Route$PatternMatchedEvent): void {


        //reset - del panel de incidencia
        //this.removeAllContent();
        //reset - del modelo form
        this.formModel();

        let arg = event.getParameter("arguments") as any;
        let id = arg.key as string;

        let view = this.getView() as View;
        let viewModel = this.getModel("viewContainer") as JSONModel;

        if (id && viewModel.getProperty("/layout") === 'OneColumn') {
            viewModel.setProperty("/layout", "TwoColumnsMidExpanded")
        }

        view.bindElement({
            path: `/Employees(ID='${id}',IsActiveEntity=true)`,
            parameters: {
                $expand: 'Title,Country,Region,City,Status'
            }
        });

    }

    private formModel(): void {
        const model = new JSONModel([]);
        this.setModel(model, "form");
    }

    public onClosePress(): void {
        const viewModel = this.getModel("viewContainer") as JSONModel;
        viewModel.setProperty("/layout", "OneColumn");
        const router = this.getRouter();
        router.navTo("RouteMaster");
    }
}