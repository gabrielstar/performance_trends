describe('HTML tests', () => {
    it('should have JMeter link', () => {
        cy.visit('http://localhost:3000/tools')
        cy.contains('JMeter')
    })
})