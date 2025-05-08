using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.DTOs;
using WebApiRouter.Models;


namespace WebApiRouter.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ServicosController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public ServicosController(RouterDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<ActionResult<ServicoResponseDTO>> CriarServico([FromBody] ServicoCreateDTO dto)
        {
            var servico = new Servico
            {
                Datacriacao = DateTime.Now,
                Datafechamento = null,
                SituacaoServicoId = 1,
                FinalidadeId = dto.FinalidadeId,
                RotaId = dto.RotaId,
                PessoajuridicaId = dto.PessoajuridicaId,
                PessoafisicaId = dto.PessoafisicaId,
                Observacao = dto.Observacao
            };

            _context.Servicos.Add(servico);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(ObterServicoPorId), new { id = servico.Id }, await MapToDTO(servico.Id));
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> AtualizarServico(int id, [FromBody] ServicoUpdateDTO dto)
        {
            if (id != dto.Id)
                return BadRequest("ID do serviço não confere com a URL.");

            var servico = await _context.Servicos.FindAsync(id);
            if (servico == null)
                return NotFound("Serviço não encontrado.");

            servico.SituacaoServicoId = dto.SituacaoServicoId;
            servico.FinalidadeId = dto.FinalidadeId;
            servico.RotaId = dto.RotaId;
            servico.PessoajuridicaId = dto.PessoajuridicaId;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpPut("{id}/situacao")]
        public async Task<ActionResult> AtualizarSituacaoServico(int id, [FromBody] ServicoUpdateDTO dto)
        {
            if (id != dto.Id)
                return BadRequest("ID do serviço não confere com a URL.");

            var servico = await _context.Servicos.FindAsync(id);
            if (servico == null)
                return NotFound("Serviço não encontrado.");

            servico.SituacaoServicoId = dto.SituacaoServicoId;

            await _context.SaveChangesAsync();
            return NoContent();
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletarServico(int id)
        {
            var servico = await _context.Servicos.FindAsync(id);
            if (servico == null)
                return NotFound("Serviço não encontrado.");

            _context.Servicos.Remove(servico);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ServicoResponseDTO>> ObterServicoPorId(int id)
        {
            var dto = await MapToDTO(id);
            if (dto == null)
                return NotFound("Serviço não encontrado.");

            return Ok(dto);
        }

        private async Task<ServicoResponseDTO?> MapToDTO(int id)
        {
            return await _context.Servicos
                .Where(s => s.Id == id)
                .Include(s => s.Pessoajuridica)
                .ThenInclude(pj => pj.IdenderecoNavigation)
                .Select(s => new ServicoResponseDTO
                {
                    Id = s.Id,
                    Datacriacao = s.Datacriacao,
                    Datafechamento = s.Datafechamento,
                    Situacao = s.SituacaoServico.Descricao,
                    Finalidade = s.Finalidade.Descricao,
                    CodigoRota = s.Rota.Codigo,
                    NomePessoaJuridica = s.Pessoajuridica.Nome,
                    Observacao = s.Observacao,


                    // Mapeamento das propriedades do Endereço
                    Logradouro = s.Pessoajuridica.IdenderecoNavigation.Logradouro,
                    Numero = s.Pessoajuridica.IdenderecoNavigation.Numero,
                    Bairro = s.Pessoajuridica.IdenderecoNavigation.Bairro,
                    Cidade = s.Pessoajuridica.IdenderecoNavigation.Cidade,
                    Estado = s.Pessoajuridica.IdenderecoNavigation.Estado

                })
                .FirstOrDefaultAsync();
        }

        [HttpGet("rota/{rotaId}")]
        public async Task<ActionResult<IEnumerable<ServicoResponseDTO>>> ObterServicosPorRota(int rotaId)
        {
            var existeRota = await _context.Rota.AnyAsync(r => r.Id == rotaId);
            if (!existeRota)
                return NotFound($"Rota com ID {rotaId} não encontrada.");

            var servicos = await _context.Servicos
                .Where(s => s.RotaId == rotaId)
                .Include(s => s.Pessoajuridica) // Carrega a PessoaJuridica
                    .ThenInclude(pj => pj.IdenderecoNavigation) // Carrega o Endereco da PessoaJuridica
                .Select(s => new ServicoResponseDTO
                {
                    Id = s.Id,
                    Datacriacao = s.Datacriacao,
                    Datafechamento = s.Datafechamento,
                    Situacao = s.SituacaoServico.Descricao,
                    Finalidade = s.Finalidade.Descricao,
                    CodigoRota = s.Rota.Codigo,
                    NomePessoaJuridica = s.Pessoajuridica.Nome,
                    Observacao = s.Observacao,

                    // Mapeamento das propriedades do Endereço
                    Logradouro = s.Pessoajuridica.IdenderecoNavigation.Logradouro,
                    Numero = s.Pessoajuridica.IdenderecoNavigation.Numero,
                    Bairro = s.Pessoajuridica.IdenderecoNavigation.Bairro,
                    Cidade = s.Pessoajuridica.IdenderecoNavigation.Cidade,
                    Estado = s.Pessoajuridica.IdenderecoNavigation.Estado
                }).OrderByDescending(x => x.Situacao == "Aberto").ThenBy(x => x.Id)
                .ToListAsync();

            return Ok(servicos);
        }
    }
}