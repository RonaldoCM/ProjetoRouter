namespace WebApiRouter.DTOs
{
    public class PessoaFisicaCreateDTO
    {
        public string Nome { get; set; } = null!;
        public string? Cpf { get; set; }
        public string? Telefone { get; set; }
    }
}
