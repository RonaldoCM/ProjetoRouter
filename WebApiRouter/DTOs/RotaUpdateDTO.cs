namespace WebApiRouter.DTOs
{
    public class RotaUpdateDTO
    {
        public int Id { get; set; }

        public int SituacaoRotaId { get; set; }

        public string? Observacao { get; set; }

        public sbyte Ativo { get; set; }
    }
}
