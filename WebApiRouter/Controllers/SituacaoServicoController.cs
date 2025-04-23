using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.Models;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SituacaoServicoController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public SituacaoServicoController(RouterDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<SituacaoServico>>> GetSituacoes()
        {
            return await _context.SituacaoServicos.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<SituacaoServico>> GetSituacao(int id)
        {
            var situacao = await _context.SituacaoServicos.FindAsync(id);

            if (situacao == null)
            {
                return NotFound();
            }

            return situacao;
        }
    }
}
