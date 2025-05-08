namespace WebApiRouter.DTOs
{
    public class PessoaFisicaResponseDTO
    {
        public int? Id { get; set; } = null!;
        public string Nome { get; set; } = null!;
        public string? Cpf { get; set; } = null!;
        public string? Telefone { get; set; } = null!;
    }
}
