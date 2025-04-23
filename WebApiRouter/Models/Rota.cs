using System;
using System.Collections.Generic;

namespace WebApiRouter.Models;

/// <summary>
/// CADASTRO DAS ROTAS
/// </summary>
public partial class Rota
{
    public int Id { get; set; }

    public string Codigo { get; set; } = null!;

    public DateTime Datacriacao { get; set; }

    public DateTime? Datafechamento { get; set; }

    public string? Observacao { get; set; }

    /// <summary>
    /// COLUNA PARA VALIDAR SE A ROTA ESTÁ ATIVA OU NÃO.
    /// </summary>
    public sbyte Ativo { get; set; }

    public int SituacaoRotaId { get; set; }

    public virtual ICollection<Servico> Servicos { get; set; } = new List<Servico>();

    public virtual SituacaoRota SituacaoRota { get; set; } = null!;
}
