using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.Models;
using WebApiRouter.DTOs;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PessoaFisicaController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public PessoaFisicaController(RouterDbContext context)
        {
            _context = context;
        }
        
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Pessoafisica>>> GetPessoafisicas()
        {
            return await _context.Pessoafisicas.ToListAsync();
        }
        
        [HttpGet("{id}")]
        public async Task<ActionResult<Pessoafisica>> GetPessoafisica(int id)
        {
            var pessoa = await _context.Pessoafisicas.FindAsync(id);

            if (pessoa == null)
            {
                return NotFound();
            }

            return pessoa;
        }
        
        [HttpPut("{id}")]
        public async Task<ActionResult> PutPessoafisica(int id, Pessoafisica pessoa)
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
                if (!PessoafisicaExists(id))
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
        public async Task<ActionResult<Pessoafisica>> PostPessoafisica(PessoaFisicaCreateDTO pessoaDTO)
        {
            var novaPF = new Pessoafisica
            {
                Nome = pessoaDTO.Nome,
                Cpf = pessoaDTO.Cpf,
                Telefone = pessoaDTO.Telefone,
                Ativo = 1,
                TipopessoaId = 1,
                Senha = null,
                Codigo = await GerarCodigoPessoaFisicaAsync()
            };

            _context.Pessoafisicas.Add(novaPF);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPessoaFisica", new { id = novaPF.Id }, novaPF);
        }

        private async Task<string> GerarCodigoPessoaFisicaAsync()
        {
            var ano = DateTime.UtcNow.Year;

            var totalAno = await _context.Pessoafisicas
                .Where(p => p.Codigo.StartsWith($"PF{ano}"))
                .CountAsync();

            return $"PF{ano}-{(totalAno + 1):D4}";
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeletePessoafisica(int id)
        {
            var pessoa = await _context.Pessoafisicas.FindAsync(id);
            if (pessoa == null)
            {
                return NotFound();
            }

            _context.Pessoafisicas.Remove(pessoa);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool PessoafisicaExists(int id)
        {
            return _context.Pessoafisicas.Any(e => e.Id == id);
        }
    }
}