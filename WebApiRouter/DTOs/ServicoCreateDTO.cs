namespace WebApiRouter.DTOs
{
    public class ServicoCreateDTO
    {
        public DateTime? Datacriacao { get; set; }
        public DateTime? Datafechamento { get; set; }
        public int SituacaoServicoId { get; set; }
        public int FinalidadeId { get; set; }
        public int RotaId { get; set; }
        public int PessoajuridicaId { get; set; }
    }
}
