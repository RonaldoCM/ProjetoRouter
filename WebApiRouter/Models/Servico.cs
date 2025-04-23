using System;
using System.Collections.Generic;

namespace WebApiRouter.Models;

public partial class Servico
{
    public int Id { get; set; }

    public DateTime? Datacriacao { get; set; }

    public DateTime? Datafechamento { get; set; }

    public int SituacaoServicoId { get; set; }

    public int FinalidadeId { get; set; }

    public int RotaId { get; set; }

    public int PessoajuridicaId { get; set; }

    public virtual Finalidade Finalidade { get; set; } = null!;

    public virtual Pessoajuridica Pessoajuridica { get; set; } = null!;

    public virtual Rota Rota { get; set; } = null!;

    public virtual SituacaoServico SituacaoServico { get; set; } = null!;
}
