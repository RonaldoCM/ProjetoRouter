namespace WebApiRouter.DTOs
{
    public class PessoaJuridicaCreateDTO
    {
        public string Nome { get; set; } = null!;

        public string Cnpj { get; set; } = null!;

        public string Telefone { get; set; } = null!;

        public EnderecoResponseDTO Endereco { get; set; } = null!;

        public List<PessoaFisicaCreateDTO> PessoaFisica { get; set; } = null!;
    }
}
