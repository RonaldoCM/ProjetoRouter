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

        [HttpPost("vincular-pfs")]
        public async Task<ActionResult> VincularMultiplasPessoasFisicas([FromBody] PessoaJuridicaVinculoMultiplosDTO dto)
        {
            if (dto.Idpfs == null || !dto.Idpfs.Any())
                return BadRequest("Lista de pessoas físicas está vazia.");

            var pessoaJuridica = await _context.Pessoajuridicas
                .Include(pj => pj.Pessoafisicas)
                .FirstOrDefaultAsync(pj => pj.Id == dto.Idpj);

            if (pessoaJuridica == null)
                return NotFound($"Pessoa Jurídica com ID {dto.Idpj} não encontrada.");

            var pessoasFisicas = await _context.Pessoafisicas
                .Where(pf => dto.Idpfs.Contains(pf.Id))
                .ToListAsync();

            var idsEncontrados = pessoasFisicas.Select(pf => pf.Id).ToList();
            var idsNaoEncontrados = dto.Idpfs.Except(idsEncontrados).ToList();

            if (idsNaoEncontrados.Any())
                return NotFound($"IDs de pessoas físicas não encontrados: {string.Join(", ", idsNaoEncontrados)}");

            var idsJaVinculados = pessoaJuridica.Pessoafisicas.Select(pf => pf.Id).ToList();

            var novosVinculos = pessoasFisicas
                .Where(pf => !idsJaVinculados.Contains(pf.Id))
                .ToList();

            if (!novosVinculos.Any())
                return Conflict("Todos os vínculos informados já existem.");

            foreach (var pf in novosVinculos)
            {
                pessoaJuridica.Pessoafisicas.Add(pf);
            }

            await _context.SaveChangesAsync();

            return Ok($"Vínculos criados com sucesso: {novosVinculos.Count}");
        }


        [HttpDelete("{idpj}/desvincular/{idpf}")]
        public async Task<ActionResult> DesvincularPessoaFisica(int idpj, int idpf)
        {            
            var pessoaJuridica = await _context.Pessoajuridicas
                .Include(pj => pj.Pessoafisicas)
                .FirstOrDefaultAsync(pj => pj.Id == idpj);

            if (pessoaJuridica == null)
                return NotFound($"Pessoa Jurídica com ID {idpj} não encontrada.");
            
            var pessoaFisica = pessoaJuridica.Pessoafisicas.FirstOrDefault(pf => pf.Id == idpf);

            if (pessoaFisica == null)
                return NotFound($"Pessoa Física com ID {idpf} não está vinculada à PJ {idpj}.");
            
            pessoaJuridica.Pessoafisicas.Remove(pessoaFisica);

            await _context.SaveChangesAsync();

            return Ok("Pessoa Física desvinculada com sucesso.");
        }

        [HttpGet("{idpj}/pessoas-fisicas")]
        public async Task<ActionResult<IEnumerable<Pessoafisica>>> GetPessoasFisicasVinculadas(int idpj)
        {
            var pessoaJuridica = await _context.Pessoajuridicas
                .Include(pj => pj.Pessoafisicas)
                .FirstOrDefaultAsync(pj => pj.Id == idpj);

            if (pessoaJuridica == null)
                return NotFound($"Pessoa Jurídica com ID {idpj} não encontrada.");

            return Ok(pessoaJuridica.Pessoafisicas);
        }

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