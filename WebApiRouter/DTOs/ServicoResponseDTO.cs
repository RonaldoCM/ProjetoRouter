namespace WebApiRouter.DTOs
{
    public class ServicoResponseDTO
    {
        public int Id { get; set; }
        public DateTime? Datacriacao { get; set; }
        public DateTime? Datafechamento { get; set; }
        public string Situacao { get; set; } = null!;
        public string Finalidade { get; set; } = null!;
        public string CodigoRota { get; set; } = null!;
        public string NomePessoaJuridica { get; set; } = null!;
        public string? Observacao { get; set; } = null!;

        public string Logradouro { get; set; } = null!;
        public string Numero { get; set; } = null!;
        public string Bairro { get; set; } = null!;
        public string Cidade { get; set; } = null!;
        public string Estado { get; set; } = null!;
    }
}
