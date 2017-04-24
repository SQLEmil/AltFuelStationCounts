using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ETL
{
    class FuelStation
    {
        public string fuel_type_code { get; set; }
        public string station_name { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string owner_type_code { get; set; }
        public FederalAgency federal_agency { get; set; }
    }

    class FederalAgency
    {
        public int id { get; set; }
        public string name { get; set; }
    }
}
