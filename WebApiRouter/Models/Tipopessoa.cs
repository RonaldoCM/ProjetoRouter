using System;
using System.Collections.Generic;

namespace WebApiRouter.Models;

/// <summary>
/// CADASTRO DOS TIPOS DE PESSOA
/// </summary>
public partial class Tipopessoa
{
    public int Id { get; set; }

    public string Descricao { get; set; } = null!;

    public virtual ICollection<Pessoafisica> Pessoafisicas { get; set; } = new List<Pessoafisica>();
}
