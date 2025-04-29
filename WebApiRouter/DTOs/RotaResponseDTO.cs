namespace WebApiRouter.DTOs
{
    public class RotaResponseDTO
    {
        public int Id { get; set; }

        public string Codigo { get; set; } = null!;

        public DateTime Datacriacao { get; set; }

        public DateTime? Datafechamento { get; set; }

        public string? Observacao { get; set; }

        public sbyte Ativo { get; set; }

        public int SituacaoRotaId { get; set; }
    }
}
