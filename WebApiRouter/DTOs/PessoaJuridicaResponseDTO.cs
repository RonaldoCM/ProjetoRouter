namespace WebApiRouter.DTOs
{
    public class PessoaJuridicaResponseDTO
    {

        public int Id { get; set; }
        public string Nome { get; set; }
        public string Cnpj { get; set; }
        public string Telefone { get; set; }
        public string Codigo { get; set; }

        public EnderecoCreateDTO Endereco { get; set; }

    }
}
