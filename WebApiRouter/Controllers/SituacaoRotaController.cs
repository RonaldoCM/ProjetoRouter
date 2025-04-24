
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.Models;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SituacaoRotaController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public SituacaoRotaController(RouterDbContext context)
        {
            _context = context;
        }
       
        [HttpGet]
        public async Task<ActionResult<IEnumerable<SituacaoRota>>> GetSituacoes()
        {
            return await _context.SituacaoRota.ToListAsync();
        }
        
        [HttpGet("{id}")]
        public async Task<ActionResult<SituacaoRota>> GetSituacao(int id)
        {
            var situacaoRota = await _context.SituacaoRota.FindAsync(id);

            if (situacaoRota == null)
            {
                return NotFound();
            }

            return situacaoRota;
        }       
    }
}