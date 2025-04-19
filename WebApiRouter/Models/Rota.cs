namespace WebApiRouter.Models;

public partial class Rota
{
    public int Id { get; set; }

    public string Codigo { get; set; } = null!;

    public DateTime Datacriacao { get; set; }

    public DateTime? Datafechamento { get; set; }

    public string? Observacao { get; set; }

    public sbyte Ativo { get; set; }

    public int Idsituacao { get; set; }

    public virtual Situacao IdsituacaoNavigation { get; set; } = null!;
}
