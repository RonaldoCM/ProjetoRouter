using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.Models;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TipoPessoaController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public TipoPessoaController(RouterDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Tipopessoa>>> GetTipopessoas()
        {
            return await _context.Tipopessoas.ToListAsync();
        }
        
        [HttpGet("{id}")]
        public async Task<ActionResult<Tipopessoa>> GetTipopessoa(int id)
        {
            var tipo = await _context.Tipopessoas.FindAsync(id);

            if (tipo == null)
            {
                return NotFound();
            }

            return tipo;
        }
    }
}