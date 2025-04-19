using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.Models;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SituacaoController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public SituacaoController(RouterDbContext context)
        {
            _context = context;
        }
       
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Situacao>>> GetSituacoes()
        {
            return await _context.Situacoes.ToListAsync();
        }
        
        [HttpGet("{id}")]
        public async Task<ActionResult<Situacao>> GetSituacao(int id)
        {
            var situacao = await _context.Situacoes.FindAsync(id);

            if (situacao == null)
            {
                return NotFound();
            }

            return situacao;
        }       
    }
}