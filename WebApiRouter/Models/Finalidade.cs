namespace WebApiRouter.Models;

public partial class Finalidade
{
    public int Id { get; set; }

    public string Descricao { get; set; } = null!;

    public virtual ICollection<Servico> Servicos { get; set; } = new List<Servico>();
}
