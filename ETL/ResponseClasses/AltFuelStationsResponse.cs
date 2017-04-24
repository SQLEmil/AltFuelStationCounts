using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ETL
{
    class AltFuelStationsResponse
    {
        public int total_results { get; set; }
        public string station_locator_url { get; set; }
        public IEnumerable<FuelStation> fuel_stations { get; set; }
    }
}
