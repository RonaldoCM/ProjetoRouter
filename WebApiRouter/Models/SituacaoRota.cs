using System;
using System.Collections.Generic;

namespace WebApiRouter.Models;

/// <summary>
/// SITUAÇÃO DA ROTA
/// </summary>
public partial class SituacaoRota
{
    public int Id { get; set; }

    public string Nome { get; set; } = null!;

    public virtual ICollection<Rota> Rota { get; set; } = new List<Rota>();
}
