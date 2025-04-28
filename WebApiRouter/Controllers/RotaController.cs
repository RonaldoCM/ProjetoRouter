
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.DTOs;
using WebApiRouter.Models;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RotaController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public RotaController(RouterDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Rota>>> GetRotas()
        {
            return await _context.Rota.OrderByDescending(x => x.SituacaoRotaId == 1).ThenByDescending(x => x.Datacriacao).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Rota>> GetRota(int id)
        {
            var rota = await _context.Rota.FindAsync(id);

            if (rota == null)
            {
                return NotFound();
            }

            return rota;
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> PutRota(int id, Rota rota)
        {
            if (id != rota.Id)
            {
                return BadRequest();
            }

            _context.Entry(rota).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RotaExists(id))
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

        [HttpPatch("{id}")]
        public async Task<ActionResult> AtualizarRota(int id, [FromBody] RotaUpdateDTO dto)
        {
            var rota = await _context.Rota.FindAsync(id);

            if (rota == null)
            {
                return NotFound();
            }

            rota.Ativo = dto.Ativo;
            rota.Observacao = dto.Observacao;

            if (dto.Ativo == 0 && rota.Datafechamento == null)
            {
                rota.Datafechamento = DateTime.Now;
            }

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RotaExists(id))
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
        public async Task<ActionResult<Rota>> PostRota(RotaCreateDTO rotaDTO)
        {
            var novaRota = new Rota
            {
                Observacao = rotaDTO.Observacao,
                Datacriacao = DateTime.UtcNow,
                Ativo = 1,
                SituacaoRotaId = 1,
                Codigo = await GerarCodigoAsync()
            };

            _context.Rota.Add(novaRota);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetRota", new { id = novaRota.Id }, novaRota);
        }

        private async Task<string> GerarCodigoAsync()
        {
            var hoje = DateTime.UtcNow.Date;

            var totalHoje = await _context.Rota
                .Where(r => r.Datacriacao.Date == hoje)
                .CountAsync();

            // Formato: R20250417-0001
            return $"R{hoje:yyyyMMdd}-{(totalHoje + 1):D4}";
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteRota(int id)
        {
            var rota = await _context.Rota.FindAsync(id);
            if (rota == null)
            {
                return NotFound();
            }

            _context.Rota.Remove(rota);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RotaExists(int id)
        {
            return _context.Rota.Any(e => e.Id == id);
        }
    }
}