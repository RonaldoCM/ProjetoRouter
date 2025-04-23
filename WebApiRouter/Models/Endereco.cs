using System;
using System.Collections.Generic;

namespace WebApiRouter.Models;

/// <summary>
/// CADASTRO DOS ENDEREÇOS
/// </summary>
public partial class Endereco
{
    public int Id { get; set; }

    public string Logradouro { get; set; } = null!;

    public string Numero { get; set; } = null!;

    public string Bairro { get; set; } = null!;

    public string Cidade { get; set; } = null!;

    public string Estado { get; set; } = null!;

    public sbyte Ativo { get; set; }

    public virtual ICollection<Pessoajuridica> Pessoajuridicas { get; set; } = new List<Pessoajuridica>();
}
