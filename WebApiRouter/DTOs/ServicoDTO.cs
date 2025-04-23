namespace WebApiRouter.DTOs
{
    public class ServicoDTO
    {
        public int Id { get; set; }
        public DateTime? Datacriacao { get; set; }
        public DateTime? Datafechamento { get; set; }
        public string Situacao { get; set; } = null!;
        public string Finalidade { get; set; } = null!;
        public string CodigoRota { get; set; } = null!;
        public string NomePessoaJuridica { get; set; } = null!;
    }
}
