using WebApiRouter.Models;

namespace WebApiRouter.DTOs
{
    public class PessoaJuridicaResponseDTO
    {

        public int Id { get; set; }

        public string Nome { get; set; } = null!;

        public string Cnpj { get; set; } = null!;

        public string Telefone { get; set; } = null!;

        public string Codigo { get; set; } = null!;

        public EnderecoCreateDTO Endereco { get; set; } = null!;

        public List<Pessoafisica> PessoaFisica { get; set; } = null!;

    }
}
