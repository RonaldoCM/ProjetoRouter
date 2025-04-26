namespace WebApiRouter.DTOs
{
    public class ServicoUpdateDTO : ServicoCreateDTO
    {
        public int Id { get; set; }
        public int SituacaoServicoId { get; set; }
    }
}
