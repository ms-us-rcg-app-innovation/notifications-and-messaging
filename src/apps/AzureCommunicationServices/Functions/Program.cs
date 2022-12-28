using Azure.Communication.Email;
using Azure.Data.Tables;
using Microsoft.Extensions.Azure;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;


var host = new HostBuilder()

    .ConfigureFunctionsWorkerDefaults()       
    .ConfigureServices((context, services) =>
    {
        // add azure storage account table service
        services.AddAzureClients(builder =>
        {
            var saConnectionString = context.Configuration.GetValue<string>("SA_CONNECTION_STRING");
            builder.AddTableServiceClient(saConnectionString);
        });

        // add azure communication services connection string
        services.AddSingleton(sp =>
        {
            var acsConnectionString = context.Configuration.GetValue<string>("ACS_CONNECTION_STRING");
            EmailClient emailClient = new(acsConnectionString);

            return emailClient;
        });
    })
    .Build();

host.Run();
