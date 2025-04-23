namespace WebApiRouter.Models;

public partial class Tipopessoa
{
    public int Id { get; set; }

    public string Descricao { get; set; } = null!;

    public virtual ICollection<Pessoafisica> Pessoafisicas { get; set; } = new List<Pessoafisica>();
}
