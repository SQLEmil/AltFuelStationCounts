using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using Newtonsoft.Json;
using System.Data.SqlClient;

namespace ETL
{
    class Program
    {
        static HttpClient client = new HttpClient();

        static void Main(string[] args)
        {
            RunAsync(args).Wait();
        }

        static async Task RunAsync(string[] args)
        {
            string apiKey;
            string connectionString;

            CheckArgs(args, out apiKey, out connectionString);

            ConfigureHttpRequestHeaders(apiKey);

            Console.WriteLine("Press any key to begin loading alt fuel station data...");
            Console.ReadLine();

            HttpResponseMessage response = await client.GetAsync($"https://developer.nrel.gov/api/alt-fuel-stations/v1.json?api_key={apiKey}&status=E&fuel_type=BD,CNG,ELEC,HY,LNG,LPG");

            if (response.IsSuccessStatusCode)
            {
                await LoadDatabaseFromResponse(connectionString, response);
            }
            else
            {
                Console.WriteLine("API request failed! Error message:");
                Console.WriteLine(await response.Content.ReadAsStringAsync());
            }

            Console.WriteLine("Press any key to exit...");
            Console.ReadLine();

            client.Dispose();

            return;
        }

        private static async Task LoadDatabaseFromResponse(string connectionString, HttpResponseMessage response)
        {
            string responseJson = await response.Content.ReadAsStringAsync();
            var responseObject = JsonConvert.DeserializeObject<AltFuelStationsResponse>(responseJson);

            using (SqlConnection sqlConnection = new SqlConnection(connectionString))
            {
                sqlConnection.Open();

                foreach (FuelStation f in responseObject.fuel_stations)
                {
                    InsertFuelStation(sqlConnection, f);
                }
            }
        }

        private static void InsertFuelStation(SqlConnection sqlConnection, FuelStation f)
        {
            string insertStatement;
            string StationName;
            string City;
            string State;
            string OwnerTypeCode;
            string FuelTypeCode;
            string FederalAgencyId;
            string FederalAgencyName;

            if (f.station_name == null)
                StationName = "NULL";
            else
                StationName = $"N'{f.station_name.Replace("'", "''")}'";

            if (f.city == null)
                City = "NULL";
            else
                City = $"N'{f.city.Replace("'", "''")}'";

            if (f.state == null)
                State = "NULL";
            else
                State = $"N'{f.state}'";

            if (f.owner_type_code == null)
                OwnerTypeCode = "NULL";
            else
                OwnerTypeCode = $"N'{f.owner_type_code}'";

            if (f.fuel_type_code == null)
                FuelTypeCode = "NULL";
            else
                FuelTypeCode = $"N'{f.fuel_type_code}'";

            if (f.federal_agency == null)
            {
                FederalAgencyId = "NULL";
                FederalAgencyName = "NULL";
            }
            else
            {
                FederalAgencyId = f.federal_agency.id.ToString();
                FederalAgencyName = $"N'{f.federal_agency.name.Replace("'", "''")}'";
            }

            insertStatement = $"insert [App].[StationDump] ( [StationName], [City], [State], [OwnerTypeCode], [FuelTypeCode], [FederalAgencyId], [FederalAgencyName]) values ( {StationName}, {City}, {State}, {OwnerTypeCode}, {FuelTypeCode}, {FederalAgencyId}, {FederalAgencyName})";
            new SqlCommand(insertStatement, sqlConnection).ExecuteNonQuery();
        }

        private static void ConfigureHttpRequestHeaders(string apiKey)
        {
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        private static void CheckArgs(string[] args, out string apiKey, out string connectionString)
        {
            if (args.Length != 4)
            {
                string serverInstance;
                string userName;
                string password;

                Console.WriteLine("Please provide your API key:");
                apiKey = Console.ReadLine();
                Console.WriteLine("Please provide the destination server instance:");
                serverInstance = Console.ReadLine();
                Console.WriteLine("Please provide the user name:");
                userName = Console.ReadLine();
                Console.WriteLine("Please provide the password:");
                password = Console.ReadLine();
                connectionString = $"server={serverInstance};user id={userName};password={password};initial catalog=reporting;multipleactiveresultsets=True;application name=AltFuelStationETL";
            }
            else
            {
                apiKey = args[0];
                connectionString = $"server={args[1]};user id={args[2]};password={args[3]};initial catalog=reporting;multipleactiveresultsets=True;application name=AltFuelStationETL";
            }
        }
    }
}
