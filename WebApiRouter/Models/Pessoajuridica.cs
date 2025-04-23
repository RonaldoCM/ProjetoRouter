using System;
using System.Collections.Generic;

namespace WebApiRouter.Models;

/// <summary>
/// CADASTRO DAS PESSOAS JURÍDICAS
/// </summary>
public partial class Pessoajuridica
{
    public int Id { get; set; }

    public string Codigo { get; set; } = null!;

    public string Nome { get; set; } = null!;

    public string Cnpj { get; set; } = null!;

    public sbyte Ativo { get; set; }

    public int Idendereco { get; set; }

    public string? Telefone { get; set; }

    public virtual Endereco IdenderecoNavigation { get; set; } = null!;

    public virtual ICollection<Servico> Servicos { get; set; } = new List<Servico>();

    public virtual ICollection<Pessoafisica> Pessoafisicas { get; set; } = new List<Pessoafisica>();
}
