sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/logaligroup/employeessfe/test/integration/FirstJourney',
		'com/logaligroup/employeessfe/test/integration/pages/EmployeesList',
		'com/logaligroup/employeessfe/test/integration/pages/EmployeesObjectPage'
    ],
    function(JourneyRunner, opaJourney, EmployeesList, EmployeesObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/logaligroup/employeessfe') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheEmployeesList: EmployeesList,
					onTheEmployeesObjectPage: EmployeesObjectPage
                }
            },
            opaJourney.run
        );
    }
);