using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.DTOs;
using WebApiRouter.Models;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PessoaJuridicaController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public PessoaJuridicaController(RouterDbContext context)
        {
            _context = context;
        }
        
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Pessoajuridica>>> GetPessoajuridicas()
        {
            return await _context.Pessoajuridicas.ToListAsync();
        }
        
        [HttpGet("{id}")]
        public async Task<ActionResult<Pessoajuridica>> GetPessoajuridica(int id)
        {
            var pessoa = await _context.Pessoajuridicas.FindAsync(id);

            if (pessoa == null)
            {
                return NotFound();
            }

            return pessoa;
        }
        
        [HttpPut("{id}")]
        public async Task<ActionResult> PutPessoajuridica(int id, Pessoajuridica pessoa)
        {
            if (id != pessoa.Id)
            {
                return BadRequest();
            }

            _context.Entry(pessoa).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PessoajuridicaExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return NoContent();
        }
        
        [HttpPost]
        public async Task<ActionResult<Pessoajuridica>> PostPessoajuridica(PessoaJuridicaCreateDTO pessoaJuridicaDTO)
        {
            var endereco = new Endereco
            {
                Logradouro = pessoaJuridicaDTO.Endereco.Logradouro,
                Numero = pessoaJuridicaDTO.Endereco.Numero,
                Bairro = pessoaJuridicaDTO.Endereco.Bairro,
                Cidade = pessoaJuridicaDTO.Endereco.Cidade,
                Estado = pessoaJuridicaDTO.Endereco.Estado,
                Ativo = 1
            };

            _context.Enderecos.Add(endereco);
            await _context.SaveChangesAsync();

            var novaPJ = new Pessoajuridica
            {
                Nome = pessoaJuridicaDTO.Nome,
                Cnpj = pessoaJuridicaDTO.Cnpj,
                Ativo = 1,
                Idendereco = endereco.Id,
                Codigo = await GerarCodigoPessoaJuridicaAsync()
            };

            _context.Pessoajuridicas.Add(novaPJ);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPessoaJuridica", new { id = novaPJ.Id }, novaPJ);

        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeletePessoajuridica(int id)
        {
            var pessoa = await _context.Pessoajuridicas.FindAsync(id);
            if (pessoa == null)
            {
                return NotFound();
            }

            _context.Pessoajuridicas.Remove(pessoa);
            await _context.SaveChangesAsync();

            return NoContent();
        }
/*
        [HttpPost("vincular-pfs")]
        public async Task<ActionResult> VincularMultiplasPessoasFisicas([FromBody] PessoaJuridicaVinculoMultiplosDTO dto)
        {
            if (!dto.Idpfs.Any())
                return BadRequest("Lista de pessoas f�sicas est� vazia.");

            // Verifica se PJ existe
            var pjExiste = await _context.Pessoajuridicas.AnyAsync(pj => pj.Id == dto.Idpj);
            if (!pjExiste)
                return NotFound($"Pessoa Jur�dica com ID {dto.Idpj} n�o encontrada.");

            // Busca todos os PFs v�lidos
            var pfsExistentes = await _context.Pessoafisicas
                .Where(pf => dto.Idpfs.Contains(pf.Id))
                .Select(pf => pf.Id)
                .ToListAsync();

            var idsNaoEncontrados = dto.Idpfs.Except(pfsExistentes).ToList();
            if (idsNaoEncontrados.Any())
                return NotFound($"IDs de pessoas f�sicas n�o encontrados: {string.Join(", ", idsNaoEncontrados)}");

            // Busca v�nculos j� existentes
            var vinculosExistentes = await _context.Pessoajuridicas
                .Where(rel => rel.Id == dto.Idpj && dto.Idpfs.Contains(rel.Id))
                .Select(rel => rel.Pessoafisicas)
                .ToListAsync();

            // Filtra somente os novos v�nculos
            var novosVinculos = dto.Idpfs
                .Except(vinculosExistentes)
                .Select(idpf => new PessoajuridicaPessoafisica
                {
                    Idpj = dto.Idpj,
                    Idpf = idpf
                }).ToList();

            if (!novosVinculos.Any())
                return Conflict("Todos os v�nculos informados j� existem.");

            _context.PessoajuridicaPessoafisicas.AddRange(novosVinculos);
            await _context.SaveChangesAsync();

            return Ok($"V�nculos criados com sucesso: {novosVinculos.Count}");
        }

        [HttpGet("{idpj}/pessoas-fisicas")]
        public async Task<ActionResult<IEnumerable<Pessoafisica>>> GetPessoasFisicasVinculadas(int idpj)
        {
            var pjExiste = await _context.Pessoajuridicas.AnyAsync(pj => pj.Id == idpj);
            if (!pjExiste)
                return NotFound($"Pessoa Jur�dica com ID {idpj} n�o encontrada.");

            var pessoasFisicas = await _context.PessoajuridicaPessoafisicas
                .Where(rel => rel.Idpj == idpj)
                .Join(_context.Pessoafisicas,
                      rel => rel.Idpf,
                      pf => pf.Id,
                      (rel, pf) => pf)
                .ToListAsync();

            return Ok(pessoasFisicas);
        }

        [HttpDelete("{idpj}/desvincular/{idpf}")]
        public async Task<ActionResult> DesvincularPessoaFisica(int idpj, int idpf)
        {
            var relacao = await _context.PessoajuridicaPessoafisicas
                .FirstOrDefaultAsync(rel => rel.Idpj == idpj && rel.Idpf == idpf);

            if (relacao == null)
                return NotFound("V�nculo n�o encontrado.");

            _context.PessoajuridicaPessoafisicas.Remove(relacao);
            await _context.SaveChangesAsync();

            return Ok("Pessoa F�sica desvinculada com sucesso.");
        }
*/
        private bool PessoajuridicaExists(int id)
        {
            return _context.Pessoajuridicas.Any(e => e.Id == id);
        }

        private async Task<string> GerarCodigoPessoaJuridicaAsync()
        {
            var ano = DateTime.UtcNow.Year;

            var totalAno = await _context.Pessoajuridicas
                .Where(p => p.Codigo.StartsWith($"PJ{ano}"))
                .CountAsync();

            return $"PJ{ano}-{(totalAno + 1):D4}";
        }
    }
}