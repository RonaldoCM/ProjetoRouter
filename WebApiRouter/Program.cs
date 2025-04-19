using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;

var builder = WebApplication.CreateBuilder(args);

// Força o servidor a escutar em todas as interfaces de rede, incluindo 10.0.0.91
builder.WebHost.ConfigureKestrel(options =>
{
    options.Listen(System.Net.IPAddress.Any, 5251); // Ouvindo em todas as interfaces de rede no IP 10.0.0.91
});

// Adiciona serviços de controllers e Swagger
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer(); // Necessário para Swagger
builder.Services.AddSwaggerGen();           // Gera a documentação Swagger

builder.Services.AddDbContext<RouterDbContext>(options =>
    options.UseMySql(builder.Configuration.GetConnectionString("DefaultConnection"),
    ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection"))));

var app = builder.Build();

// Ativa Swagger somente no desenvolvimento
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();              // Gera o JSON da doc
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Minha API V1");
        // Mantém o /swagger como caminho
    });
}

app.UseAuthorization();           // (opcional, se for usar autenticação)

app.MapControllers();            // Mapeia seus controllers

app.Run();
