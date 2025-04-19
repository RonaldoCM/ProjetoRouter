namespace WebApiRouter.DTOs
{
    public class PessoaJuridicaVinculoMultiplosDTO
    {
        public int Idpj { get; set; }
        public List<int> Idpfs { get; set; } = new();
    }
}
