using {Employees as service} from './employees';

annotate service.Employees with @odata.draft.enabled;


annotate service.Employees with {
    ID           @Common.Label: 'Employee ID';
    FirstName    @Common.Label: 'First Name'    @title: 'First Name';
    LastName     @Common.Label: 'Last Name'     @title: 'Last Name';
    FullName     @Common.Label: 'Full Name'     @title: 'Full Name';
    BirthDate    @Common.Label: 'Birth Date'    @title: 'Birth Date';
    Image        @Common.Label: 'Image'         @title: 'Image';
    Photo        @Common.Label: 'Photo'         @title: 'Photo';
    ImageType    @Common.Label: 'Image Type'    @title: 'Image Type';
    Title        @Common.Label: 'Title'         @title: 'Title';
    Department   @Common.Label: 'Department'    @title: 'Department';
    HireDate     @Common.Label: 'Hire Date'     @title: 'Hire Date';
    CostCenter   @Common.Label: 'Cost Center'   @title: 'Cost Center';
    Status       @Common.Label: 'Status'        @title: 'Status';
    Email        @Common.Label: 'Email'         @title: 'Email';
    HomePhone    @Common.Label: 'Home Phone'    @title: 'Home Phone';
    MobilePhone  @Common.Label: 'Mobile Phone'  @title: 'Mobile Phone';
    Extension    @Common.Label: 'Extension'     @title: 'Extension';
    Country      @Common.Label: 'Country'       @title: 'Country';
    Region       @Common.Label: 'Region'        @title: 'Region';
    City         @Common.Label: 'City'          @title: 'City';
    Address      @Common.Label: 'Address'       @title: 'Address';
    PostalCode   @Common.Label: 'Postal Code'   @title: 'Postal Code';
    ToOrders     @Common.Label: 'Orders'        @title: 'Orders';
};

annotate service.VH_Titles with {
    @title : 'Titles'
    ID @Common: {
        Text           : Title,
        TextArrangement: #TextOnly
    };
};

annotate service.VH_Countries with {
    @title: 'Countries'
    ID @Common: {
        Text           : Country,
        TextArrangement: #TextOnly
    };
};

annotate service.VH_Regions with {
    @title: 'Regions'
    ID @Common: {
        Text           : Region,
        TextArrangement: #TextOnly
    };
};

annotate service.VH_Cities with {
    @title: 'Cities'
    ID @Common: {
        Text           : City,
        TextArrangement: #TextOnly
    };
};


annotate service.Employees with {
    Title      @Common: {
        Text           : Title.Title,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Titles',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Title_ID,
                ValueListProperty: 'ID'
            }]
        }
    };
    Department @Common: {
        Text           : Department.Department,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Departments',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Department_ID,
                ValueListProperty: 'ID'
            }]
        }
    };
    Status     @Common: {
        Text           : Status.Code,
        TextArrangement: #TextOnly
    };
    Country    @Common: {
        Text           : Country.Country,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Countries',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Country_ID,
                ValueListProperty: 'ID'
            }]
        }
    };
    Region     @Common: {
        Text           : Region.Region,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Regions',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: Country_ID,
                    ValueListProperty: 'Country_ID'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: Region_ID,
                    ValueListProperty: 'ID'
                }
            ],
        },
    };
    City       @Common: {
        Text           : City.City,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Cities',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: Region_ID,
                    ValueListProperty: 'Region_ID'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: City_ID,
                    ValueListProperty: 'ID'
                }
            ]
        }
    };

};

annotate service.Employees with @(
    Capabilities.FilterRestrictions       : {
        $Type                       : 'Capabilities.FilterRestrictionsType',
        FilterExpressionRestrictions: [
            {
                $Type             : 'Capabilities.FilterExpressionRestrictionType',
                Property          : FullName,
                AllowedExpressions: 'SearchExpression'
            },
            {
                $Type             : 'Capabilities.FilterExpressionRestrictionType',
                Property          : BirthDate,
                AllowedExpressions: 'SingleRange'
            },
        ]
    },
    UI.SelectionFields                    : [
        FullName,
        Country_ID,
        Region_ID,
        City_ID,
        BirthDate,
        Title_ID,
        Status_Code
    ],
    UI.HeaderInfo                         : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',
        Title         : {
            $Type: 'UI.DataField',
            Value: FullName
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: Title_ID
        },
    },
    UI.LineItem                           : [
        {
            $Type: 'UI.DataField',
            Value: Image,
        },
        {
            $Type: 'UI.DataField',
            Value: FullName,
        },
        {
            $Type: 'UI.DataField',
            Value: Title_ID
        },
        {
            $Type: 'UI.DataField',
            Value: Country_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: Region_ID
        },
        {
            $Type: 'UI.DataField',
            Value: City_ID
        },
        {
            $Type: 'UI.DataField',
            Value: BirthDate,
        },
        {
            $Type      : 'UI.DataField',
            Value      : Status_Code,
            Criticality: Status.Criticality
        },
    ],
    UI.FieldGroup #PersonalInformation    : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: Photo,
            },
            {
                $Type: 'UI.DataField',
                Value: FirstName,
            },
            {
                $Type: 'UI.DataField',
                Value: LastName,
            },
            {
                $Type: 'UI.DataField',
                Value: BirthDate,
            }
        ],
        Label: 'Personal Information'
    },
    UI.FieldGroup #OrganizationInformation: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: Title_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: Department_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: HireDate,
            },
            {
                $Type: 'UI.DataField',
                Value: CostCenter,
            },
            {
                $Type: 'UI.DataField',
                Value: Status_Code,
            }
        ],
        Label: 'Organizational Information'
    },
    UI.FieldGroup #ContactInformation     : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: Email,
            },
            {
                $Type: 'UI.DataField',
                Value: HomePhone,
            },
            {
                $Type: 'UI.DataField',
                Value: MobilePhone,
            },
            {
                $Type: 'UI.DataField',
                Value: Extension,
            }
        ],
        Label: 'Contact Information'
    },
    UI.FieldGroup #AddressInformation     : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: Country_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: Region_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: City_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: Address,
            },
            {
                $Type: 'UI.DataField',
                Value: PostalCode,
            }
        ],
        Label: 'Address Information'
    },
    UI.Facets                             : [
    {
        $Type : 'UI.CollectionFacet',
        Facets: [
            {
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#PersonalInformation',
                Label : 'Personal Information',
                ID    : 'PersonalInformation'
            },
            {
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#AddressInformation',
                Label : 'Address Information',
                ID    : 'AddressInformation'
            },
            {
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#ContactInformation',
                Label : 'Contact Information',
                ID    : 'ContactInformation'
            }
        ],
        Label : 'Main Information',
        ID    : 'MainInformation',
    },
    {
        $Type : 'UI.ReferenceFacet',
        Target : 'ToOrders/@UI.LineItem',
        Label : 'Orders',
        ID : 'ToOrders'
    },
]
);

annotate service.Orders with {
    OrderID        @title: 'Order ID';
    OrderDate      @title: 'Order Date';
    RequiredDate   @title: 'Required Date';
    CustomerID     @title: 'Customer ID';
    Freight        @title: 'Freight';
    ShipName       @title: 'Ship Name';
    ShipCountry    @title: 'Ship Country';
    ShipRegion     @title: 'Ship Region';
    ShipCity       @title: 'Ship City';
    ShipAddress    @title: 'Ship Address';
    ShipPostalCode @title: 'Ship Postal Code';
    ShippedDate    @title: 'Shipped Date';
    ShipVia        @title: 'Ship Via';
};

annotate service.Orders with @(
    UI.HeaderInfo              : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Order',
        TypeNamePlural: 'Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: Employee.FullName,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: Employee.Title_ID
        },
    },
    UI.LineItem                : [
        {
            $Type: 'UI.DataField',
            Value: OrderID
        },
        {
            $Type: 'UI.DataField',
            Value: OrderDate
        },
        {
            $Type: 'UI.DataField',
            Value: RequiredDate
        },
        {
            $Type: 'UI.DataField',
            Value: CustomerID
        },
        {
            $Type: 'UI.DataField',
            Value: Freight
        },
        {
            $Type: 'UI.DataField',
            Value: ShippedDate
        },
        {
            $Type: 'UI.DataField',
            Value: ShipName
        },
        {
            $Type: 'UI.DataField',
            Value: ShipCountry
        },
        {
            $Type: 'UI.DataField',
            Value: ShipRegion
        },
        {
            $Type: 'UI.DataField',
            Value: ShipCity
        },
        {
            $Type: 'UI.DataField',
            Value: ShipAddress
        },
        {
            $Type: 'UI.DataField',
            Value: ShipPostalCode
        },
        {
            $Type: 'UI.DataField',
            Value: ShipVia
        }
    ],
    UI.FieldGroup #OrderDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: OrderID
            },
            {
                $Type: 'UI.DataField',
                Value: CustomerID,
            },
            {
                $Type: 'UI.DataField',
                Value: OrderDate
            },
            {
                $Type: 'UI.DataField',
                Value: RequiredDate
            },
            {
                $Type: 'UI.DataField',
                Value: ShippedDate
            },
            {
                $Type: 'UI.DataField',
                Value: ShipVia,
                Label: 'Transportista'
            },
            {
                $Type: 'UI.DataField',
                Value: Freight
            }
        ],
        Label : 'Customer Details',
    },
    UI.FieldGroup #ShippingInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: ShipName
            },
            {
                $Type: 'UI.DataField',
                Value: ShipAddress
            },
            {
                $Type: 'UI.DataField',
                Value: ShipCity
            },
            {
                $Type: 'UI.DataField',
                Value: ShipRegion
            },
            {
                $Type: 'UI.DataField',
                Value: ShipPostalCode
            },
            {
                $Type: 'UI.DataField',
                Value: ShipCountry
            }
        ],
        Label: 'Shipping Information'
    },
    UI.Facets  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#OrderDetails',
            Label : 'Customer Details',
            ID : 'Customer Details'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'Shipping Information',
            ID : 'ShippingInformation'
        }
    ]
);
